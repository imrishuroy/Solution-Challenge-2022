import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/girl-table/screens/comments_screen.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/constants/constants.dart';
import '/models/discussion.dart';
import '/screens/mentor-connect/widgets/user_avatar.dart';

class DicussionCard extends StatelessWidget {
  final Discussion? discussion;
  final VoidCallback onTap;

  const DicussionCard({
    Key? key,
    required this.discussion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    final _authBloc = context.read<AuthBloc>();
    final users = discussion?.users ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          DiscussionComments.routeName,
          arguments: DiscussionCommentsArgs(discussion: discussion),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF8EAFF),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Text(
                  discussion?.title ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),

                Text('( by ${discussion?.author?.name ?? 'anonymous'} )'),

                // discussion?.author != null
                //     ? Row(
                //         children: [
                //           const Text('by '),
                //           // UserAvatar(
                //           //     radius: 12.0,
                //           //     imageUrl:
                //           //         discussion?.author?.photUrl ?? errorImage),
                //           // const SizedBox(width: 5.0),
                //           Text('${discussion?.author?.name}'),
                //         ],
                //       )
                //     : const Text('anonymous'),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 70.0,
                  child: Text(
                    discussion?.description ?? 'N/A',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _canvas.width * 0.32,
                      child: SizedBox(
                        width: 100.0,
                        height: 50.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: discussion?.users.length,
                          itemBuilder: (context, index) {
                            return UserAvatar(
                              radius: 14.0,
                              imageUrl: discussion?.users[index]?.photUrl ??
                                  errorImage,
                            );
                          },
                        ),
                      ),
                    ),
                    if (!users.contains(_authBloc.state.user))
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                        ),
                        onPressed: onTap,
                        child: const Text('Join Table'),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
