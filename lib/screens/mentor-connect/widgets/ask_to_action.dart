import 'package:flutter/material.dart';

class AskToAction {
  static Future<bool> deleteAction({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            content,
            // 'Do you want to signOut ?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes',
                // style: TextStyle(
                //   color: Colors.red,
                //   fontSize: 15.0,
                // ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                // style: TextStyle(
                //   color: Colors.green,
                //   fontSize: 15.0,
                // ),
              ),
            ),
          ],
        );
      },
    );

    return await result ?? false;
  }
}
