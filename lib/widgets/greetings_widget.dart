import 'package:flutter/material.dart';

final Shader linearGradient = const LinearGradient(
  colors: <Color>[
    Color.fromRGBO(40, 200, 253, 1),
    Colors.white,
  ],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

class GreetingsWidget extends StatelessWidget {
  final double height;

  const GreetingsWidget({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Hello',
              style: TextStyle(
                fontSize: height < 750 ? 40.0 : 60.0,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
                foreground: Paint()..shader = linearGradient,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(
                  'There',
                  style: TextStyle(
                    fontSize: height < 750 ? 47.0 : 67.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
                Text(
                  ' !',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient,
                    //color: Colors.green,
                    // foreground: Paint()..shader = linearGradient,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
