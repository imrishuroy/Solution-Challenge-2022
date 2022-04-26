part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, succuss, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;
  final bool showPassword;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
    required this.showPassword,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      failure: Failure(),
      showPassword: false,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, password, status, failure, showPassword];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    Failure? failure,
    bool? showPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
