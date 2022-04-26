import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '/repositories/auth/auth_repository.dart';

class ForgotPaswordScreen extends StatefulWidget {
  static const String routeName = '/password-reset';

  const ForgotPaswordScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ForgotPaswordScreen(),
    );
  }

  @override
  _ForgotPaswordScreenState createState() => _ForgotPaswordScreenState();
}

class _ForgotPaswordScreenState extends State<ForgotPaswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  String? _email;
  bool _isLoading = false;
  void showSnackBar({
    BuildContext? context,
    String? title,
    Color? backgroundColor = Colors.red,
  }) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          '$title',
          style: const TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _forgotPassword(BuildContext context) async {
    final _authRepo = context.read<AuthRepository>();
    final form = _formKey.currentState!;
    FocusScope.of(context).unfocus();
    if (form.validate()) {
      form.save();
      try {
        setState(() {
          _isLoading = true;
        });

        await _authRepo.forgotPassword(email: _email);
        // UserCredential userCredential =

        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context: context,
          title: 'Successful, check your email',
          backgroundColor: Colors.green,
        );
      } on FirebaseException catch (error) {
        setState(() {
          _isLoading = false;
        });
        print(error);
        showSnackBar(context: context, title: '${error.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 38, 40, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 141, 82, 1),
        centerTitle: true,
        title: const Text('Forgot Password'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 160.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'We will send a verificaion link your registered email.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20.0),
                  TextFormField(
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                    key: const ValueKey('email'),
                    onSaved: (value) => _email = value,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) => !(value!.contains('@gmail.com'))
                        ? 'Invalid Email'
                        : null,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.green,
                      ),
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                      ),
                      hintText: 'Enter Your Email',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: () => _forgotPassword(context),
                      child: const Padding(
                        padding: EdgeInsets.all(11.5),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 17.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Login Again',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// - **invalid-email**:
///  - Thrown if the email address is not valid.
/// - **user-not-found**:
///  - Thrown if there is no user corresponding to the email address.
