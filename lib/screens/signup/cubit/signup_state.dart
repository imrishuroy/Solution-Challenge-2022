part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, succuss, error }

class SignupState extends Equatable {
  final String? email;
  final String? password;
  final SignupStatus status;
  final Failure failure;

  final bool showPassword;

  bool get isFormValid => email!.isNotEmpty && password!.isNotEmpty;

  const SignupState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
    required this.showPassword,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      status: SignupStatus.initial,
      failure: Failure(),
      showPassword: false,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, password, status, failure, showPassword];

  SignupState copyWith({
    String? email,
    String? password,
    SignupStatus? status,
    Failure? failure,
    bool? showPassword,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
