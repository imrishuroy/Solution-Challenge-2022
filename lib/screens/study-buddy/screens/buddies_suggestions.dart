import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/constants/constants.dart';
import '/models/study_buddy.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/screens/study-buddy/cubit/study_buddy_cubit.dart';
import '/widgets/display_interests.dart';
import '/widgets/loading_indicator.dart';
import 'buddy_connected.dart';

class BuddiesSuggestionsArgs {
  final StudyBuddy? currentUser;

  BuddiesSuggestionsArgs({required this.currentUser});
}

class BuddiesSuggestions extends StatelessWidget {
  static const String routeName = '/buddies-recommendations';
  final StudyBuddy? currentUser;
  const BuddiesSuggestions({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  static Route route({required BuddiesSuggestionsArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => StudyBuddyCubit(
          studyBuddyRepository: context.read<StudyBuddyRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..loadRecommendedBuddies(studyBuddy: args.currentUser),
        child: BuddiesSuggestions(
          currentUser: args.currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<StudyBuddyCubit, StudyBuddyState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == StudyBuddyStatus.succuss) {
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
                    onTap: () {},
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GridView.builder(
                        itemCount: state.recommendedBuddies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 0.87,
                        ),
                        itemBuilder: (context, index) {
                          final buddy = state.recommendedBuddies[index];
                          return GestureDetector(
                            onTap: () {},

                            // Navigator.of(context).pushNamed(
                            //     MenteeConnected.routeName,
                            //     arguments: MenteeConnectedArgs(
                            //         mentee: mentee, mentor: state.mentor)),
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
                                          buddy?.user?.photUrl ?? errorImage,
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
                                      buddy?.user?.name ?? 'N/A',
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6.0),
                                    DisplayInterests(
                                        interests: buddy?.interests ?? []),
                                    const SizedBox(height: 12.0),
                                    SizedBox(
                                      height: 35.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          context
                                              .read<StudyBuddyCubit>()
                                              .connect(
                                                currentUserId:
                                                    currentUser?.user?.uid,
                                                buddyUserId: buddy?.user?.uid,
                                              );

                                          Navigator.of(context).pushNamed(
                                            BuddyConnected.routeName,
                                            arguments: BuddyConnectedArgs(
                                              currentUser: currentUser,
                                              buddy: buddy,
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
                  'Finding the\nbest buddies\n for you!!',
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
    ));
  }
}
