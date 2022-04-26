import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/study-group/screens/join_group.dart';
import '/constants/constants.dart';
import '/models/study_group.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
import '/screens/study-group/cubit/study_group_cubit.dart';
import '/models/study_group_user.dart';

class GroupSuggestionsArgs {
  final StudyGroupUser? user;

  GroupSuggestionsArgs({required this.user});
}

class StudyGroupsSuggestions extends StatelessWidget {
  static const String routeName = '/groups-suggestions';

  final StudyGroupUser? user;

  const StudyGroupsSuggestions({
    Key? key,
    required this.user,
  }) : super(key: key);

  static Route route({required GroupSuggestionsArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => StudyGroupCubit(
          authBloc: context.read<AuthBloc>(),
          studyBuddyRepository: context.read<StudyBuddyRepository>(),
        )..loadGroupsSuggestions(user: args.user),
        child: StudyGroupsSuggestions(user: args.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudyGroupCubit, StudyGroupState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == StudyGroupStatus.loading) {
            return const LoadingIndicator();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  Header(
                    title: 'Recommended Groups',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.studyGroups.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final group = state.studyGroups[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            JoinGroup.routeName,
                            arguments: JoinGroupArgs(user: user, group: group),
                          ),
                          child: GroupTile(group: group),
                        );
                      },
                    ),
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

class GroupTile extends StatelessWidget {
  const GroupTile({
    Key? key,
    required this.group,
  }) : super(key: key);

  final StudyGroup? group;

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: const Color(0xffF8EAFF),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            SizedBox(
              height: 15.0,
              child: Text(
                group?.name ?? '',
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: _canvas.height * 0.1,
              child: Text(group?.description ?? 'N/A'),
            ),
          ],
        ),
      ),
    );
  }
}
