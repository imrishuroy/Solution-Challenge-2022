import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/enums/nav_item.dart';
import '/nav/bloc/nav_bloc.dart';
import '/nav/nav_screen.dart';
import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';
import '/screens/mentor-connect/widgets/ask_to_action.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/enums/user_type.dart';
import '/screens/chat/chat_screen.dart';
import '/constants/constants.dart';
import '/models/mentee.dart';
import '/models/mentor.dart';

class MentorConnectedArgs {
  final Mentee? mentee;
  final Mentor? mentor;

  MentorConnectedArgs({
    required this.mentee,
    required this.mentor,
  });
}

class MentorConnected extends StatelessWidget {
  final Mentor? mentor;
  final Mentee? mentee;
  static const String routeName = '/mentor-connected';
  const MentorConnected({
    Key? key,
    required this.mentee,
    required this.mentor,
  }) : super(key: key);

  static Route route({required MentorConnectedArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => MentorConnectCubit(
            mentorConnectRepository: context.read<MentorConnectRepository>(),
            authBloc: context.read<AuthBloc>()),
        child: MentorConnected(
          mentee: args.mentee,
          mentor: args.mentor,
        ),
      ),
    );
  }

  void cancelConnection(BuildContext context) async {
    final result = await AskToAction.deleteAction(
        context: context,
        title: 'Cancel Connection',
        content: 'Do you want to cancel connection ?');
    print('Result $result');
    if (result) {
      context.read<MentorConnectCubit>().deleteConnect(
            mentorId: mentor?.user?.uid,
            menteeId: mentee?.user?.uid,
            mentee: mentee,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('THis runs p');
        if (context.read<MentorConnectCubit>().state.mentee?.connectedMentor !=
            null) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(NavScreen.routeName, (route) => false);
          context
              .read<NavBloc>()
              .add(const UpdateNavItem(item: NavItem.mentorConnect));
        }
        print('THis runs r');

        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                Header(
                  onBackTap: context
                              .read<MentorConnectCubit>()
                              .state
                              .mentee
                              ?.connectedMentor !=
                          null
                      ? () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              NavScreen.routeName, (route) => false);
                          context.read<NavBloc>().add(
                              const UpdateNavItem(item: NavItem.mentorConnect));
                        }
                      : null,
                  title: 'Your Mentor',
                  onTap: () => cancelConnection(context),
                  tralingIcon: Icons.clear,
                  tralingIconColor: Colors.red,
                ),
                const SizedBox(height: 40.0),
                // Container(
                //   height: 100.0,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: primaryColor,
                //     borderRadius: BorderRadius.circular(12.0),
                //   ),
                //   child: const Center(
                //     child: Text(
                //       'Find Your Mentor',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 22.0,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage(mentee?.user?.photUrl ?? errorImage),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          mentee?.user?.name ?? '',
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'Mentee',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    Image.asset(
                      'assets/images/share.png',
                      height: 50.0,
                      width: 50.0,
                      color: primaryColor,
                    ),
                    Column(
                      ///crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage(mentor?.user?.photUrl ?? errorImage),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          mentor?.user?.name ?? '',
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'Mentor',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20.0,
                          letterSpacing: 1.2,
                        ),
                        children: [
                          const TextSpan(text: 'Congratulations !!\n'),
                          const TextSpan(text: 'You got mentor\n'),
                          TextSpan(
                            text: mentor?.user?.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: ChatScreenArgs(
                      mentee: mentee,
                      mentor: mentor,
                      userType: UserType.mentee,
                    ),
                  ),
                  child: Container(
                    height: 50.0,
                    width: 240.0,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Chat with your mentor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 18.0,
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
