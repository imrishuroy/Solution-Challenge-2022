import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/mentor.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';
import 'mentee_profile.dart';
import 'mentee_suggested_mentors.dart';
import '/widgets/loading_indicator.dart';
import 'mentor_connected.dart';

class MenteeScreen extends StatelessWidget {
  static const String routeName = '/mentee';
  const MenteeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => MentorConnectCubit(
            authBloc: context.read<AuthBloc>(),
            mentorConnectRepository: context.read<MentorConnectRepository>())
          ..loadMentee(),
        child: const MenteeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MentorConnectCubit, MentorConnectState>(
      listener: (context, state) async {
        if (state.mentee == null &&
            state.status == MentorConnectStatus.succuss) {
          final result =
              await Navigator.of(context).pushNamed(MenteeProfile.routeName);
          if (result == true) {
            context.read<MentorConnectCubit>().loadMentee();
          }
        }
      },
      builder: (context, state) {
        // if (state.status == MentorConnectStatus.loading) {
        //   return const Scaffold(body: LoadingIndicator());
        // }

        // if (state.mentee == null) {
        //   return MenteeProfile();
        // } else

        if (state.mentee?.connectedMentor != null) {
          return BlocProvider(
            create: (context) => MentorConnectCubit(
                mentorConnectRepository:
                    context.read<MentorConnectRepository>(),
                authBloc: context.read<AuthBloc>()),
            child: MentorConnected(
              mentee: state.mentee,
              mentor: Mentor(
                user: state.mentee?.connectedMentor,
                interests: const [],
              ),
            ),
          );
        } else if (state.mentee != null) {
          print('This rusn m');
          // context.read<MentorConnectCubit>().loadMentorsSuggestions();
          return BlocProvider<MentorConnectCubit>(
            create: (context) => MentorConnectCubit(
                mentorConnectRepository:
                    context.read<MentorConnectRepository>(),
                authBloc: context.read<AuthBloc>())
              ..loadMentorsSuggestions(),
            child: MenteeSuggestedMentors(
              mentee: state.mentee,
            ),
          );
        }

        return const Scaffold(body: LoadingIndicator());
      },
    );
  }
}
