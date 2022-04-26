import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/display_interests.dart';
import '/screens/mentor-connect/screens/mentor/mentor_profile.dart';
import '/models/mentee.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/models/mentor.dart';
import '/screens/mentor-connect/screens/mentee/mentee_profile.dart';
import '/widgets/loading_indicator.dart';

import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';
import '/constants/constants.dart';
import 'mentor_connected.dart';

class MenteeSuggestedMentors extends StatefulWidget {
  final Mentee? mentee;
  static const String routeName = '/mentors-suggestions';
  const MenteeSuggestedMentors({Key? key, required this.mentee})
      : super(key: key);

  @override
  State<MenteeSuggestedMentors> createState() => _MenteeSuggestedMentorsState();
}

class _MenteeSuggestedMentorsState extends State<MenteeSuggestedMentors> {
  @override
  void initState() {
    // context.read<MentorConnectCubit>().loadMentorsSuggestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MentorConnectCubit, MentorConnectState>(
        listener: (context, state) {
          // if (state.isMenteeConnected) {
          //   Navigator.of(context).pushNamed(MentorConnected.routeName,
          //       arguments: MentorConnectedArgs(
          //           mentee: state.mentee, mentor: state.mentor));
          // }
        },
        builder: (context, state) {
          print('Suggestions -- ${state.suggestedMentors}');
          print('Mentee from suggestions screns -${state.mentee}');
          if (state.status == MentorConnectStatus.succuss) {
            print('Mentor ---------- ${state.mentee}');
            // if (state.mentee == null) {
            //   return TextButton(
            //       onPressed: () {},
            //       child: Text('Add your profile to get mentors'));
            // }
            return SafeArea(
              child: state.mentee?.connectedMentor != null
                  ? MentorConnected(
                      mentee: state.mentee,
                      mentor: Mentor(
                        user: state.mentee?.connectedMentor,
                        interests: const [],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        children: [
                          Header(
                            title: 'Mentors Suggestions',
                            onTap: () => Navigator.of(context)
                                .pushNamed(MenteeProfile.routeName),
                          ),
                          const SizedBox(height: 20.0),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  context
                                      .read<MentorConnectCubit>()
                                      .loadMentorsSuggestions();
                                },
                                child: GridView.builder(
                                  itemCount: state.suggestedMentors.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15.0,
                                    mainAxisSpacing: 15.0,
                                    childAspectRatio: 0.87,
                                  ),
                                  itemBuilder: (context, index) {
                                    final mentor =
                                        state.suggestedMentors[index];
                                    return GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        MentorProfile.routeName,
                                        arguments: MentorProfileArgs(
                                          mentor: mentor,
                                        ),
                                      ),
                                      child: Card(
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
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
                                                backgroundImage: NetworkImage(
                                                    mentor?.user?.photUrl ??
                                                        errorImage),
                                              ),
                                              const SizedBox(height: 7.0),
                                              Text(
                                                mentor?.user?.name ?? 'N/A',
                                                style: const TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 6.0),
                                              DisplayInterests(
                                                  interests:
                                                      mentor?.interests ?? []),
                                              const SizedBox(height: 12.0),
                                              SizedBox(
                                                height: 35.0,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                            MentorConnectCubit>()
                                                        .connect(
                                                            mentorId: mentor
                                                                ?.user?.uid,
                                                            menteeId: widget
                                                                .mentee
                                                                ?.user
                                                                ?.uid,

                                                            //  state
                                                            //     .mentee
                                                            //     ?.user
                                                            //     ?.uid,
                                                            mentee:
                                                                widget.mentee);

                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      MentorConnected.routeName,
                                                      arguments:
                                                          MentorConnectedArgs(
                                                        mentee: widget.mentee,
                                                        mentor: mentor,
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Connect'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
                    'Finding the\nbest mentor\n for you!!',
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
