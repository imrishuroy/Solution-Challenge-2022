import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/display_interests.dart';
import '/screens/mentor-connect/screens/mentor/create_mentor_profile.dart';
import '/screens/mentor-connect/widgets/header.dart';
import 'mentee_connected.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';
import '/constants/constants.dart';

class MenteeSuggestions extends StatelessWidget {
  static const String routeName = '/mentee-suggestions';
  const MenteeSuggestions({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => MentorConnectCubit(
          authBloc: context.read<AuthBloc>(),
          mentorConnectRepository: context.read<MentorConnectRepository>(),
        )..loadMenteesSuggestions(),
        child: const MenteeSuggestions(),
      ),
    );
  }

  void connectMentor() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MentorConnectCubit, MentorConnectState>(
        listener: (context, state) {},
        builder: (context, state) {
          print('Suggestions -- ${state.suggestedMentors}');
          print('Mentee from suggestions screns -${state.mentee}');
          if (state.status == MentorConnectStatus.succuss) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    Header(
                      title: 'Mentees Suggestions',
                      onTap: () => Navigator.of(context)
                          .pushNamed(CreateMentorProfile.routeName),
                    ),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GridView.builder(
                          itemCount: state.suggestedMentees.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                            // childAspectRatio: 0.87,
                            childAspectRatio: 1.09,
                          ),
                          itemBuilder: (context, index) {
                            final mentee = state.suggestedMentees[index];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  MenteeConnected.routeName,
                                  arguments: MenteeConnectedArgs(
                                      mentee: mentee, mentor: state.mentor)),
                              // onTap: () => Navigator.of(context).pushNamed(
                              //     MentorProfile.routeName,
                              //     arguments: MentorProfileArgs(mentor: mentor)),
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    //mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 8.0),
                                      CircleAvatar(
                                        radius: 30.0,
                                        child: ClipOval(
                                          child: Image.network(
                                            mentee?.user?.photUrl ?? errorImage,
                                            height: 60.0,
                                            width: 60.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // backgroundImage: NetworkImage(
                                        //     mentee?.user?.photUrl ??
                                        //         errorImage),
                                      ),
                                      const SizedBox(height: 7.0),
                                      Text(
                                        mentee?.user?.name ?? 'N/A',
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6.0),
                                      DisplayInterests(
                                          interests: mentee?.interests ?? []),
                                      const SizedBox(height: 12.0),
                                      // SizedBox(
                                      //   height: 35.0,
                                      //   child: ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(12.0),
                                      //       ),
                                      //     ),
                                      //     onPressed: () {
                                      //       // context
                                      //       //     .read<MentorConnectCubit>()
                                      //       //     .connectMentor(
                                      //       //         mentorId: mentee?.user?.uid,
                                      //       //         menteeId: state
                                      //       //             .mentee?.user?.uid);
                                      //       // Navigator.of(context).pushNamed(
                                      //       //   MentorConnected.routeName,
                                      //       //   arguments: MentorConnectedArgs(
                                      //       //     mentee: state.mentee,
                                      //       //     mentor: mentee,
                                      //       //   ),
                                      //       // );
                                      //     },
                                      //     child: const Text('Connect'),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Finding the\nbest mentees\n for you!!',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  LoadingIndicator(
                    height: 100.0,
                    width: 100.0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
