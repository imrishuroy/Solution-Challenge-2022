import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/services/services.dart';
import '/widgets/custom_text_field.dart';
import '/screens/signup/signup_screen.dart';
import '/repositories/auth/auth_repository.dart';
import '/widgets/error_dialog.dart';
import '/widgets/google_button.dart';
import '/widgets/loading_indicator.dart';
import 'package:universal_platform/universal_platform.dart';
import '/constants/constants.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().signInWithEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              //   backgroundColor: Color.fromRGBO(29, 38, 40, 1),
              body: state.status == LoginStatus.submitting
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: LoadingIndicator(),
                    )
                  : Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/login-top.png',
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              //  vertical: 20.0,
                            ),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextField(
                                  onChanged: (value) => context
                                      .read<LoginCubit>()
                                      .emailChanged(value),
                                  textInputType: TextInputType.emailAddress,
                                  validator: (value) =>
                                      Services.validateEmail(value!),
                                  hintText: 'Enter your email',
                                ),
                                const SizedBox(height: 20.0),
                                CustomTextField(
                                  onChanged: (value) => context
                                      .read<LoginCubit>()
                                      .passwordChanged(value),
                                  textInputType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Invalid Password';
                                    }
                                    return null;
                                  },
                                  hintText: 'Enter your password',
                                  isPassowrdField: true,
                                ),
                                const SizedBox(height: 30.0),
                                SizedBox(
                                  width: 300.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                    ),
                                    onPressed: () => _submitForm(context,
                                        state.status == LoginStatus.submitting),
                                    child: const Padding(
                                      padding: EdgeInsets.all(11.5),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 17.5,
                                          color: Colors.white,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                const Text(
                                  'OR',
                                  style: TextStyle(
                                    color: primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15.0),
                                if (UniversalPlatform.isIOS)
                                  SizedBox(
                                    width: 300.0,
                                    child: SignInWithAppleButton(
                                      onPressed: () {
                                        if (!UniversalPlatform.isIOS) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => const ErrorDialog(
                                                content:
                                                    'Apple login is currently available only on iOS devices!'),
                                          );
                                        } else {
                                          context
                                              .read<LoginCubit>()
                                              .appleLogin();
                                        }
                                      },
                                      style: SignInWithAppleButtonStyle.black,
                                    ),
                                  ),
                                const SizedBox(height: 20.0),
                                GoogleSignInButton(
                                  onPressed: () =>
                                      context.read<LoginCubit>().googleSignIn(),
                                  title: 'Sign in with Google',
                                ),
                                const SizedBox(height: 25.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Need an account?',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, SignupScreen.routeName);
                                      },
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
