import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/services/services.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/loading_indicator.dart';
import 'package:universal_platform/universal_platform.dart';
import '/repositories/auth/auth_repository.dart';
import '/screens/signup/cubit/signup_cubit.dart';
import '/constants/constants.dart';
import '/widgets/error_dialog.dart';
import '/widgets/google_button.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  SignupScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: SignupScreen(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
      //showSnackBar(context: context, title: 'SignUp Succussfull');
    }
  }

  void showSnackBar({BuildContext? context, String? title}) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(
            '$title',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          print('Current state ${state.status}');
          if (state.status == SignupStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
              ),
            );
          }
        },
        builder: (context, state) {
          return state.status == SignupStatus.submitting
              ? const LoadingIndicator()
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
                                'Sign Up',
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
                                  .read<SignupCubit>()
                                  .emailChanged(value),
                              textInputType: TextInputType.emailAddress,
                              validator: (value) =>
                                  Services.validateEmail(value!),
                              hintText: 'Enter your email',
                            ),
                            const SizedBox(height: 20.0),
                            CustomTextField(
                              onChanged: (value) => context
                                  .read<SignupCubit>()
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
                                    state.status == SignupStatus.submitting),
                                child: const Padding(
                                  padding: EdgeInsets.all(11.5),
                                  child: Text(
                                    'Sign Up',
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
                                  text: 'Sign Up with Apple',
                                  onPressed: () {
                                    if (!UniversalPlatform.isIOS) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => const ErrorDialog(
                                            content:
                                                'Apple login is currently available only on iOS devices!'),
                                      );
                                    } else {
                                      context.read<SignupCubit>().appleLogin();
                                    }
                                  },
                                  style: SignInWithAppleButtonStyle.black,
                                ),
                              ),
                            const SizedBox(height: 20.0),
                            GoogleSignInButton(
                              onPressed: () => context
                                  .read<SignupCubit>()
                                  .singupWithGoogle(),
                              title: 'Sign Up with Google',
                            ),
                            const SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Have an Account?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16.0,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 35.0),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
