import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/mentor-connect/screens/mentor/mentor_profile.dart';
import '/models/mentee.dart';
import '/models/mentor.dart';
import '/screens/mentor-connect/widgets/ask_to_action.dart';
import 'package:url_launcher/url_launcher.dart';
import '/constants/constants.dart';
import '/screens/chat/widget/chat_bubble.dart';
import '/widgets/loading_indicator.dart';
import '/enums/user_type.dart';
import '/screens/chat/cubit/chat_cubit.dart';
import '/repositories/chat/chat_repo.dart';

class ChatScreenArgs {
  final Mentee? mentee;
  final Mentor? mentor;
  final UserType userType;

  ChatScreenArgs({
    required this.mentee,
    required this.mentor,
    required this.userType,
  });
}

class ChatScreen extends StatefulWidget {
  final Mentee? mentee;
  final Mentor? mentor;
  final UserType userType;

  static const String routeName = '/chats';
  const ChatScreen({
    Key? key,
    required this.mentee,
    required this.mentor,
    required this.userType,
  }) : super(key: key);

  static Route route({required ChatScreenArgs args}) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<ChatCubit>(
        create: (context) => ChatCubit(
          chatRepository: context.read<ChatRepository>(),
          menteeId: args.mentee?.user?.uid,
          mentorId: args.mentor?.user?.uid,
          userType: args.userType,
        ),
        child: ChatScreen(
          mentee: args.mentee,
          mentor: args.mentor,
          userType: args.userType,
        ),
      ),
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      final _chatCubit = context.read<ChatCubit>();
      if (_chatCubit.state.message.isNotEmpty) {
        _chatCubit.sendChat();
      }
      _chatTextController.clear();
    }
  }

  void _makePhoneCall() async {
    String user = widget.userType == UserType.mentee ? 'mentee' : 'mentor';

    final result = await AskToAction.deleteAction(
        context: context,
        title: 'Call $user',
        content: 'Do you want to call $user ?');
    if (result) {
      if (widget.userType == UserType.mentee) {
        launch('tel://${widget.mentee?.phNo}');
      } else {
        launch('tel://${widget.mentor?.phNo}');
      }
    }
  }

  final _chatTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == ChatStatus.loading) {
                return const LoadingIndicator();
              }
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: _canvas.width * 0.24),
                        Container(
                          height: 40.0,
                          width: 100,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Your Mentee',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _makePhoneCall(),
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (widget.userType == UserType.mentee) {
                              Navigator.of(context).pushNamed(
                                MentorProfile.routeName,
                                arguments:
                                    MentorProfileArgs(mentor: widget.mentor),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.account_circle,
                            //   color: tralingIconColor,
                            // color: color == primaryColor ? primaryColor : Colors.white,
                          ),
                        )
                      ],
                    ),

                    // Header(title: 'Your Mentee', onTap: () {}),
                    const SizedBox(height: 15.0),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        itemCount: state.chats.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final chat = state.chats[index];

                          print('Chat user type ${chat?.userType}');

                          return ChatBubble(
                            text: chat?.messageContent ?? '',
                            isCurrentUser: chat?.userType == widget.userType,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 10, top: 10),
                        height: 60,
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextFormField(
                                controller: _chatTextController,
                                onChanged: (value) => context
                                    .read<ChatCubit>()
                                    .messageChanged(value, widget.userType),
                                // controller: _chatTextController,
                                decoration: const InputDecoration(
                                    hintText: 'Write message...',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            FloatingActionButton(
                              onPressed: () => _submitForm(
                                  context, state.status == ChatStatus.loading),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              backgroundColor: state.isFormValid
                                  ? primaryColor
                                  : Colors.grey,
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
