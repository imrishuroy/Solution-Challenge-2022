import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/display_messge.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
import '/models/study_group.dart';
import '/screens/mentor-connect/widgets/header.dart';
import '/screens/study-group/cubit/study_group_cubit.dart';
import '/models/study_group_user.dart';

class JoinGroupArgs {
  final StudyGroupUser? user;
  final StudyGroup? group;

  JoinGroupArgs({required this.user, required this.group});
}

class JoinGroup extends StatelessWidget {
  static const String routeName = '/joinGroup';

  final StudyGroupUser? user;
  final StudyGroup? group;
  const JoinGroup({
    Key? key,
    required this.user,
    required this.group,
  }) : super(key: key);

  static Route route({required JoinGroupArgs args}) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => StudyGroupCubit(
          studyBuddyRepository: context.read<StudyBuddyRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: JoinGroup(
          user: args.user,
          group: args.group,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudyGroupCubit, StudyGroupState>(
        listener: (context, state) {
          if (state.status == StudyGroupStatus.succuss) {
            DisplayMessage.succussMessage(context, title: 'Group Joined');
            Navigator.of(context).pop();
          }
        },
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(
                    title: 'Join Group',
                    onTap: null,
                    tralingIconColor: Colors.white,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    group?.name ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    group?.description ?? 'N/A',
                    style: const TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  const SizedBox(height: 40.0),
                  Center(
                    child: SizedBox(
                      height: 40.0,
                      width: 110.0,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<StudyGroupCubit>().joinGroup(
                                studyGroupUserId: user?.user?.uid,
                                groupId: group?.groupId,
                              );
                        },
                        icon: const Icon(Icons.group_add),
                        label: const Text('Join'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
