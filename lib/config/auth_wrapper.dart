import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/loading_indicator.dart';
import '/screens/login/login_screen.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/nav/nav_screen.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/authwrapper';

  const AuthWrapper({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AuthWrapper(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        } else if (state.status == AuthStatus.authenticated) {
          print('Auth State user - ${state.user?.uid}');

          Navigator.of(context).pushNamed(NavScreen.routeName);
        }
      },
      child: const Scaffold(body: LoadingIndicator()),
    );
  }
}
