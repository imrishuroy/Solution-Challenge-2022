import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/girl-table/commnets/commnets_cubit.dart';
import '/screens/girl-table/widgets/comment_bubble.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/discussion.dart';
import '/repositories/girl-table/girl_table_repository.dart';

import '/screens/mentor-connect/widgets/user_avatar.dart';
import '/widgets/loading_indicator.dart';
import '/constants/constants.dart';

class DiscussionCommentsArgs {
  final Discussion? discussion;

  DiscussionCommentsArgs({required this.discussion});
}

class DiscussionComments extends StatefulWidget {
  static const String routeName = '/discussionComments';
  final Discussion? discussion;
  const DiscussionComments({
    Key? key,
    required this.discussion,
  }) : super(key: key);

  static Route route({required DiscussionCommentsArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => CommnetsCubit(
            authBloc: context.read<AuthBloc>(),
            girlTableRepository: context.read<GirlTableRepository>(),
            discussionId: args.discussion?.discussionId),
        child: DiscussionComments(
          discussion: args.discussion,
        ),
      ),
    );
  }

  @override
  State<DiscussionComments> createState() => _DiscussionCommentsState();
}

class _DiscussionCommentsState extends State<DiscussionComments> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<CommnetsCubit>().sendChat();
      //  _formKey.currentState?.reset();
      _chatTextController.clear();
    }
  }

  final _chatTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    final _authBloc = context.read<AuthBloc>();

    return Scaffold(
      body: BlocConsumer<CommnetsCubit, CommnetsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == CommentsStatus.loading) {
            return const LoadingIndicator();
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 250.0,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                SizedBox(
                                  width: _canvas.width * 0.7,
                                  child: Text(
                                    widget.discussion?.title ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              height: 78.0,
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.discussion?.description ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
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
                                      itemCount:
                                          widget.discussion?.users.length,
                                      itemBuilder: (context, index) {
                                        return UserAvatar(
                                          borderColor: Colors.white,
                                          imageUrl: widget.discussion
                                                  ?.users[index]?.photUrl ??
                                              errorImage,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                  '${state.discussionComments.length} comments',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                                //   Text('${discussion.}')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: state.discussionComments.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final comment = state.discussionComments[index];

                      return CommentBubble(
                        isCurrentUser: _authBloc.state.user == comment?.author,
                        text: comment?.comment ?? '',
                        authorImage: comment?.author?.photUrl,
                        authorName: comment?.author?.name,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _chatTextController,
                            onChanged: (value) => context
                                .read<CommnetsCubit>()
                                .commentChanged(value),
                            decoration: const InputDecoration(
                              hintText: 'Write your view here...',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        FloatingActionButton(
                          onPressed: () => _submitForm(
                              context, state.status == CommentsStatus.loading),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor:
                              state.isFormValid ? primaryColor : Colors.grey,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
