import 'package:flutter/material.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/constants/constants.dart';
import '/models/mentor.dart';

class MentorProfileArgs {
  final Mentor? mentor;

  const MentorProfileArgs({required this.mentor});
}

class MentorProfile extends StatelessWidget {
  final Mentor? mentor;
  static const String routeName = '/mentor-profile';
  const MentorProfile({Key? key, required this.mentor}) : super(key: key);

  static Route route({required MentorProfileArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MentorProfile(mentor: args.mentor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 550.0,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10.0),
                    Header(
                      color: Colors.white,
                      title: 'Connect with Mentor',
                      onTap: () {},
                      // onTap: () => Navigator.of(context)
                      //     .pushNamed(MentorsSuggestions.routeName),
                    ),
                    const SizedBox(height: 30.0),
                    CircleAvatar(
                      ///  backgroundColor: Colors.transparent,
                      radius: 60,
                      child: ClipOval(
                        child: Image.network(
                          mentor?.user?.photUrl ?? errorImage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    Text(
                      mentor?.user?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // const Text(
                    //   'Mentor',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 17.0,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 15.0),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: (mentor?.interests ?? []).map((interest) {
                          String text = '';
                          if (mentor?.interests.last != interest) {
                            text = '$interest     |';
                          } else {
                            text = interest ?? '';
                          }

                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 10.0),
                            //  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          );
                        }).toList()),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            height: 70.0,
                            width: 200.0,
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                child: Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text(
                                  'Linkedin   |',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Github   |',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Twitter   |',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Website',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Center(child: Text('Sessions')),
                              ),
                              Container(
                                height: 40.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Center(child: Text('Chat')),
                              ),
                              Container(
                                height: 40.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Center(child: Text('Upvote')),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  const Text(
                    '  INTERESTS',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    children: (mentor?.interests ?? [])
                        .map(
                          (interest) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40.0,
                              width: interest != null && interest.length != 1
                                  ? interest.length * 18
                                  : 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Center(child: Text(interest ?? '')),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10.0)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
