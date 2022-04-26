import 'package:flutter/material.dart';
import '/constants/constants.dart';
import '/screens/mentor-connect/widgets/user_avatar.dart';

class CommentBubble extends StatelessWidget {
  const CommentBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
    required this.authorImage,
    required this.authorName,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  final String? authorImage;
  final String? authorName;

  @override
  Widget build(BuildContext context) {
    final _canvas = MediaQuery.of(context).size;
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
            color: const Color(0xffF8EAFF),
            // color: isCurrentUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserAvatar(
                      radius: 14.0,
                      imageUrl: authorImage ?? errorImage,
                    ),
                    const SizedBox(width: 7.0),
                    SizedBox(
                      width: _canvas.width * 0.6,
                      child: Text(
                        authorName ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(text,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: const Color(0xff555555),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          )
                      // color: isCurrentUser ? Colors.white : Colors.black87),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
