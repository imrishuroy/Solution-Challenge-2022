import 'package:flutter/material.dart';
import '/constants/constants.dart';

class DiscussionHeader extends StatelessWidget {
  const DiscussionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18.0),
          bottomRight: Radius.circular(18.0),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 20.0),
            Text(
              'GIRL TABLE',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Giving a helping hand to each other',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
