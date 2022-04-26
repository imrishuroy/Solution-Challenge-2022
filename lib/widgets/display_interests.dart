import 'package:flutter/material.dart';

class DisplayInterests extends StatelessWidget {
  final List<String?> interests;

  const DisplayInterests({
    Key? key,
    required this.interests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: interests.map((interest) {
        String text = '';
        if (interests.last != interest) {
          text = '$interest |';
        } else {
          text = interest ?? '';
        }

        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          //  padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(text),
        );
      }).toList()),
    );

    // SizedBox(
    //   height: 20.0,
    //   child:

    // ListView.separated(
    //   scrollDirection: Axis.horizontal,
    //   itemCount: interests.length,
    //   itemBuilder: (context, index) {
    //     return Padding(
    //       padding: const EdgeInsets.only(left: 8.0),
    //       child: Text(
    //         interests[index] ?? 'N/A',
    //         style: const TextStyle(color: primaryColor),
    //       ),
    //     );
    //   },
    //   separatorBuilder: (context, int index) {
    //     return const Text(' | ');
    //   },
    // ),
    // );
  }
}
