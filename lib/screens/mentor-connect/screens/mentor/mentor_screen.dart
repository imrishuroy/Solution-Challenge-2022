import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/mentor-connect/screens/mentor/mentee_suggestions.dart';
import '/screens/mentor-connect/screens/mentor/create_mentor_profile.dart';
import '/widgets/loading_indicator.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/screens/mentor-connect/cubit/mentor_connect_cubit.dart';

class MentorScreen extends StatelessWidget {
  static const String routeName = '/mentor';
  const MentorScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => MentorConnectCubit(
            authBloc: context.read<AuthBloc>(),
            mentorConnectRepository: context.read<MentorConnectRepository>())
          ..loadMentor(),
        child: const MentorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MentorConnectCubit, MentorConnectState>(
      listener: (context, state) async {
        if (state.mentor == null &&
            state.status == MentorConnectStatus.succuss) {
          final result = await Navigator.of(context)
              .pushNamed(CreateMentorProfile.routeName);
          if (result == true) {
            context.read<MentorConnectCubit>().loadMentor();
          }
        }
      },
      builder: (context, state) {
        print('Mentor from mentor screen -- ${state.mentor}');

        if (state.mentor != null) {
          return BlocProvider(
            create: (context) => MentorConnectCubit(
              authBloc: context.read<AuthBloc>(),
              mentorConnectRepository: context.read<MentorConnectRepository>(),
            )..loadMenteesSuggestions(),
            child: const MenteeSuggestions(),
          );
        }

        return const Scaffold(body: LoadingIndicator());
      },
    );
  }
}
