import 'package:flutter/material.dart';
import '/constants/constants.dart';

class Header extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onBackTap;
  final Color? color;
  final IconData? tralingIcon;
  final Color tralingIconColor;
  final bool hideIcons;
  const Header(
      {Key? key,
      required this.title,
      required this.onTap,
      this.hideIcons = false,
      this.onBackTap,
      this.color = primaryColor,
      this.tralingIcon = Icons.account_circle,
      this.tralingIconColor = primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          hideIcons ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        if (!hideIcons)
          IconButton(
            onPressed: onBackTap ?? () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: color,
            ),
          ),
        // SizedBox(
        //   width: 45.0,
        // ),
        Container(
          height: 30.0,
          width: title.length * 9,
          // width: 140.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: color == primaryColor ? Colors.white : primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (!hideIcons)
          IconButton(
            onPressed: onTap,
            icon: Icon(
              tralingIcon,
              color: tralingIconColor,
              // color: color == primaryColor ? primaryColor : Colors.white,
            ),
          )
      ],
    );
  }
}
