import 'package:flutter/material.dart';
import '/constants/constants.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Color borderColor;

  const UserAvatar({
    Key? key,
    this.imageUrl = errorImage,
    this.radius = 18.0,
    this.borderColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius - 1,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
