import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const GoogleSignInButton({
    Key? key,
    @required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 47.0,
        width: 300.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              style: BorderStyle.solid,
              width: 0.0,
            ),
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.asset('assets/google.png'),
                ),
              ),
              //   const SizedBox(width: 10.0),
              const Spacer(),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
