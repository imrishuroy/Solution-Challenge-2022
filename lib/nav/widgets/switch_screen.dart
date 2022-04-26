import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/repositories/profile/profile_repository.dart';
import '/screens/profile/cubit/profile_cubit.dart';
import '/screens/dashboard/dashboard.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/girl-table/girl_table_repository.dart';
import '/screens/girl-table/cubit/girl_table_cubit.dart';
import '/screens/mentor-connect/screens/choose_usertype.dart';
import '/screens/girl-table/girl_table.dart';
import '/screens/profile/profile_screen.dart';
import '/enums/nav_item.dart';

class SwitchScreen extends StatelessWidget {
  final NavItem navItem;

  const SwitchScreen({Key? key, required this.navItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (navItem) {
      case NavItem.dashboard:
        return const DashBoard();

      case NavItem.girlTable:
        return BlocProvider(
          create: (context) => GirlTableCubit(
            girlTableRepository: context.read<GirlTableRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..loadTopics(),
          child: const GirlTable(),
        );

      case NavItem.mentorConnect:
        return const ChooseUserType();

      case NavItem.profile:
        return BlocProvider(
          create: (context) => ProfileCubit(
            authBloc: context.read<AuthBloc>(),
            profileRepository: context.read<ProfileRepository>(),
          )..loadUserProfile(),
          child: const ProfileScreen(),
        );

      default:
        return const Center(
          child: Text('Wrong'),
        );
    }
  }
}
