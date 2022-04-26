import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '/constants/constants.dart';

class LoadingIndicator extends StatelessWidget {
  final double? height;
  final double? width;
  const LoadingIndicator({Key? key, this.height = 50.0, this.width = 50.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: const SpinKitFadingCircle(
          color: primaryColor,
        ),
      ),
    );
  }
}
