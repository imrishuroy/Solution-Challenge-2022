import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';
import '/screens/mentor-connect/screens/mentee/mentee_screen.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/constants/constants.dart';
import 'mentor/mentor_screen.dart';

class ChooseUserType extends StatelessWidget {
  static const String routeName = 'choose-user';
  const ChooseUserType({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => MentorConnectCubit(
          authBloc: context.read<AuthBloc>(),
          mentorConnectRepository: context.read<MentorConnectRepository>(),
        ),
        child: const ChooseUserType(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 270.0,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      const Header(
                        hideIcons: true,
                        title: 'Get Connected !!',
                        onTap: null,
                        color: Colors.white,
                        tralingIcon: Icons.more_horiz,
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 130.0,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.account_circle),
                                    SizedBox(width: 5.0),
                                    Text('Hi Rishu'),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                    'We are excited to have you here as a mentor.  PotenSHEia aims to unlock new opportunities for the enthusiastic women in STEM. '),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 50.0,
                left: 15.0,
                right: 15.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  // width: 290.0,
                  height: 450.0,
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Image.asset(
                        'assets/images/connect.png',
                        height: 150.0,
                        width: 300.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 13.0),
                      const Text(
                        'JOIN US',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 220.0,
                            width: 170.0,
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 2.0),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 32.0,
                                      child: Image.asset(
                                          'assets/images/mentor.png'),
                                      // backgroundImage:
                                      //     AssetImage('assets/images/mentor.png'),
                                    ),
                                    const SizedBox(height: 20.0),
                                    const Text(
                                      'Guide juniors and aspiring developers',
                                      textAlign: TextAlign.center,
                                    ),
                                    //const SizedBox(height: 10.0),
                                    const Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // SharedPrefs().setUserType(mentor);
                                        Navigator.of(context)
                                            .pushNamed(MentorScreen.routeName);
                                      },
                                      child: const Text(
                                        'Be a mentor',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 220.0,
                            width: 170.0,
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 2.0),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 32.0,
                                      child: Image.asset(
                                          'assets/images/mentee.png'),
                                      // backgroundImage:
                                      //     AssetImage('assets/images/mentee.png'),
                                    ),
                                    const SizedBox(height: 20.0),
                                    const Text(
                                      'Find a mentor who has been in your shoes earlier.',
                                      textAlign: TextAlign.center,
                                    ),
                                    //  const SizedBox(height: 10.0),
                                    const Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        //SharedPrefs().setUserType(mentee);
                                        Navigator.of(context)
                                            .pushNamed(MenteeScreen.routeName);
                                      },
                                      child: const Text(
                                        'Find your mentor',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
