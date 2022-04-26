import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> onError(cubit, Object error, StackTrace stackTrace) async {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}
