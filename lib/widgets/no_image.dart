import 'package:flutter/material.dart';

class NoImageAvailable extends StatelessWidget {
  const NoImageAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/no-image.png',
      fit: BoxFit.cover,
    );
  }
}
