import 'package:flutter/material.dart';

class DisplayMessage {
  static void succussMessage(
    BuildContext context, {
    required String? title,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          '$title',
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void erroMessage(
    BuildContext context, {
    required String? title,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          '$title',
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
