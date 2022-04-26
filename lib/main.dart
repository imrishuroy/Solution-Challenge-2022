import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/repositories/opportunities/opportunities_repository.dart';
import '/repositories/profile/profile_repository.dart';
import '/nav/bloc/nav_bloc.dart';
import '/repositories/girl-table/girl_table_repository.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
import '/repositories/chat/chat_repo.dart';
import '/blocs/simple_bloc_observer.dart';
import '/config/auth_wrapper.dart';
import '/config/custom_router.dart';
import 'blocs/bloc/auth_bloc.dart';
import 'config/shared_prefs.dart';
import 'constants/constants.dart';
import 'repositories/auth/auth_repository.dart';
import 'repositories/mentor-connect/mentor_connect_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primaryColor, statusBarIconBrightness: Brightness.light));
  // if (kIsWeb) {
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: 'AIzaSyACn2d1FewBh4KugEvQ48DFivmTJkQzg1k',
  //     appId: '1:1812572046:web:ca0aa061fe63eba3fda6df',
  //     messagingSenderId: '1812572046',
  //     projectId: 'solution-challenge-2022-64113',
  //     storageBucket: 'solution-challenge-2022-64113.appspot.com',
  //   ),
  // );
  // } else {

  //   await Firebase.initializeApp();
  // }
  await Firebase.initializeApp();
  await SharedPrefs().init();
  EquatableConfig.stringify = kDebugMode;
  // Bloc.observer = SimpleBlocObserver();
  BlocOverrides.runZoned(() {}, blocObserver: SimpleBlocObserver());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<MentorConnectRepository>(
          create: (_) => MentorConnectRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepository(),
        ),
        RepositoryProvider<GirlTableRepository>(
          create: (_) => GirlTableRepository(),
        ),
        RepositoryProvider(
          create: (_) => StudyBuddyRepository(),
        ),
        RepositoryProvider(
          create: (_) => OpportunitiesRepository(),
        ),
        RepositoryProvider(
          create: (_) => ProfileRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NavBloc(),
          )
        ],
        child: MaterialApp(
          //  showPerformanceOverlay: true,
          theme: ThemeData(
            textTheme: const TextTheme(),
            iconTheme: const IconThemeData(color: primaryColor),
            scaffoldBackgroundColor: Colors.white,
            primaryColor: primaryColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(primary: primaryColor)),
            appBarTheme: const AppBarTheme(
              elevation: 0.0,
              titleTextStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              color: Colors.black54,
            ),
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: AuthWrapper.routeName,
        ),
      ),
    );
  }
}
