import 'package:flutter/material.dart';
import '/constants/constants.dart';

class WrapChip extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const WrapChip({
    Key? key,
    required this.isSelected,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        backgroundColor: isSelected ? primaryColor : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: primaryColor)),
        label: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : primaryColor),
        ),
      ),
    );
  }
}
