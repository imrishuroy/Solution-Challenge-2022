import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? const Color(0xffF8EBFF) : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(text,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: const Color(0xff7C7C7C),
                    )
                //.copyWith(color: Colors.black),
                //  .copyWith(color: const Color(0xff7C7C7C)),
                // color: isCurrentUser ? Colors.white : Colors.black87),
                ),
          ),
        ),
      ),
    );
  }
}
