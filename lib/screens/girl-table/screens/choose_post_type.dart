import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/nav/nav_screen.dart';
import '/screens/girl-table/cubit/girl_table_cubit.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/discussion.dart';
import '/widgets/loading_indicator.dart';
import '/repositories/girl-table/girl_table_repository.dart';

class ChoosePostTypeArgs {
  final Discussion discussion;

  ChoosePostTypeArgs({required this.discussion});
}

class ChoosePostType extends StatelessWidget {
  static const String routeName = '/choose-post-type';
  const ChoosePostType({Key? key, required this.discussion}) : super(key: key);

  final Discussion discussion;

  static Route route({required ChoosePostTypeArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider<GirlTableCubit>(
        create: (context) => GirlTableCubit(
            girlTableRepository: context.read<GirlTableRepository>(),
            authBloc: context.read<AuthBloc>()),
        child: ChoosePostType(discussion: args.discussion),
      ),
    );
  }

  void _submitForm(
    BuildContext context, {
    required bool isAnonymous,
  }) async {
    if (isAnonymous) {
      context.read<GirlTableCubit>().addTopicDiscussion(discussion: discussion);
    } else {
      context.read<GirlTableCubit>().addTopicDiscussion(
            discussion: discussion.copyWith(
                author: context.read<AuthBloc>().state.user),
          );
    }
    // context.read<NavBloc>().add(const UpdateNavItem(item: NavItem.girlTable));
    Navigator.of(context)
        .pushNamedAndRemoveUntil(NavScreen.routeName, (route) => false);

    //Navigator.of(context).pop();
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     DiscussionScreen.routeName, (route) => false,
    //     arguments: DiscussionScreenArgs(
    //       topic: Topic(topicId: discussion.topicId, title: '', labelImg: ''),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    print('Discussion -- $discussion');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/social-bg.png',
              height: 320.0,
              width: double.infinity,
            ),
            const SizedBox(height: 20.0),
            BlocConsumer<GirlTableCubit, GirlTableState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.status == GirlTableStatus.loading) {
                  return const LoadingIndicator();
                }
                return Expanded(
                  child: Column(
                    children: [
                      const Spacer(),
                      SizedBox(
                        height: 70.0,
                        width: 270.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                          ),
                          onPressed: () => _submitForm(
                            context,
                            isAnonymous: true,
                          ),
                          child: const Text(
                            'Post it Anonymous',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '-OR-',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 70.0,
                        width: 270.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                          ),
                          onPressed: () =>
                              _submitForm(context, isAnonymous: false),
                          child: const Text(
                            'Post as it is',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
