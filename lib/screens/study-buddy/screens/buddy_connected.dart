import 'package:flutter/material.dart';
import '/models/study_buddy.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/constants/constants.dart';

class BuddyConnectedArgs {
  final StudyBuddy? currentUser;
  final StudyBuddy? buddy;

  BuddyConnectedArgs({
    this.currentUser,
    this.buddy,
  });
}

class BuddyConnected extends StatelessWidget {
  final StudyBuddy? currentUser;
  final StudyBuddy? buddy;
  static const String routeName = '/mentee-connected';

  const BuddyConnected({
    Key? key,
    required this.currentUser,
    required this.buddy,
  }) : super(key: key);

  static Route route({required BuddyConnectedArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BuddyConnected(
        currentUser: args.currentUser,
        buddy: args.buddy,
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
              Header(title: 'Your Buddy', onTap: () {}),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        NetworkImage(currentUser?.user?.photUrl ?? errorImage),
                  ),
                  Image.asset(
                    'assets/images/connected.png',
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  ),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        NetworkImage(buddy?.user?.photUrl ?? errorImage),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                height: 220.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffF8EBFF),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Center(
                    child: Text(
                      'Congratulations!!\nyou got your buddy\n${buddy?.user?.name}',
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Color(0xff555555),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                // onTap: () => Navigator.of(context).pushNamed(
                //   ChatScreen.routeName,
                //   arguments: ChatScreenArgs(
                //     mentee: mentee,
                //     mentor: mentor,
                //     userType: UserType.mentor,
                //   ),
                // ),
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
                        'Chat with your buddy',
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
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
