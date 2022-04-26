import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';
import '/models/failure.dart';
import '/repositories/auth/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void showPassword(bool showPassword) {
    emit(state.copyWith(
        showPassword: !showPassword, status: SignupStatus.initial));
  }

  void signUpWithCredentials() async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      print('Email ${state.email}');
      print('Password ${state.password}');
      final user = await _authRepository.signUpWithEmailAndPassword(
        // username: state.username!,
        email: state.email!,
        password: state.password!,
      );
      if (user != null) {
        final doc = await _usersRef.doc(user.uid).get();
        if (!doc.exists) {
          _usersRef.doc(user.uid).set(user.toMap());
        }
      }

      emit(state.copyWith(status: SignupStatus.succuss));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    }
  }

  void singupWithGoogle() async {
    try {
      emit(state.copyWith(status: SignupStatus.submitting));
      final user = await _authRepository.signInWithGoogle();

      if (user != null) {
        final doc = await _usersRef.doc(user.uid).get();
        if (!doc.exists) {
          _usersRef.doc(user.uid).set(user.toMap());
        }
      }
      emit(state.copyWith(status: SignupStatus.succuss));
    } on Failure catch (error) {
      print('Error sign up google');
      emit(state.copyWith(failure: error, status: SignupStatus.error));
    }
  }

  void appleLogin() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      final user = await _authRepository.signInWithApple();
      if (user != null) {
        final doc = await _usersRef.doc(user.uid).get();
        if (!doc.exists) {
          _usersRef.doc(user.uid).set(user.toMap());
        }
      }
      emit(state.copyWith(status: SignupStatus.succuss));
    } on Failure catch (error) {
      emit(
        state.copyWith(
          status: SignupStatus.error,
          failure: Failure(message: error.message),
        ),
      );
    }
  }
}
