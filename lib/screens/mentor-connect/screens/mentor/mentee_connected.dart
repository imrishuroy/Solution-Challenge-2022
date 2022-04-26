import 'package:flutter/material.dart';
import '/enums/user_type.dart';
import '/screens/chat/chat_screen.dart';
import '/models/mentee.dart';
import '/models/mentor.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/constants/constants.dart';

class MenteeConnectedArgs {
  final Mentor? mentor;
  final Mentee? mentee;

  MenteeConnectedArgs({
    this.mentor,
    this.mentee,
  });
}

class MenteeConnected extends StatelessWidget {
  final Mentor? mentor;
  final Mentee? mentee;
  static const String routeName = 'mentee-connected';

  const MenteeConnected({
    Key? key,
    required this.mentee,
    required this.mentor,
  }) : super(key: key);

  static Route route({required MenteeConnectedArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MenteeConnected(
        mentee: args.mentee,
        mentor: args.mentor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Header(title: 'Your Mentee', onTap: () {}),
              Image.asset(
                'assets/images/person.png',
                height: 220.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15.0),
              const Text(
                'CONNECTED!!',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 220.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(mentor?.user?.photUrl ?? errorImage),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/share.png',
                          height: 50.0,
                          width: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(mentee?.user?.photUrl ?? errorImage),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  ChatScreen.routeName,
                  arguments: ChatScreenArgs(
                    mentee: mentee,
                    mentor: mentor,
                    userType: UserType.mentor,
                  ),
                ),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Chat with your mentee',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 17.0,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
