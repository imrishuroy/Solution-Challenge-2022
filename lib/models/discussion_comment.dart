import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';
import '/models/app_user.dart';

class DiscussionComment extends Equatable {
  final String? discussionId;
  final String? comment;
  final AppUser? author;
  final DateTime? createdAt;

  const DiscussionComment({
    this.discussionId,
    this.comment,
    this.author,
    this.createdAt,
  });

  DiscussionComment copyWith({
    String? discussionId,
    String? comment,
    AppUser? author,
    DateTime? createdAt,
  }) {
    return DiscussionComment(
      discussionId: discussionId ?? this.discussionId,
      comment: comment ?? this.comment,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discussionId': discussionId,
      'comment': comment,
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author?.uid),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  static Future<DiscussionComment?> fromDocument(
      {required QueryDocumentSnapshot? doc}) async {
    final data = doc?.data() as Map?;
    final authRef = data?['author'] as DocumentReference?;
    final authorSnap = await authRef?.get();

    return DiscussionComment(
      discussionId: data?['discussionId'],
      comment: data?['comment'],
      author: data?['author'] != null ? AppUser.fromDocument(authorSnap) : null,
      createdAt: data?['createdAt'] != null
          ? (data?['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // factory DiscussionComment.fromMap(Map<String, dynamic> map) {
  //   final authRef = map['author'] as DocumentReference?;
  //   //final authorSnap = await authRef?.get();

  //   return DiscussionComment(
  //     discussionId: map['discussionId'],
  //     comment: map['comment'],
  //     author: map['author'] != null ? AppUser.fromMap(map['author']) : null,
  //     createdAt: map['createdAt'] != null
  //         ? (map['createdAt'] as Timestamp).toDate()
  //         : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory DiscussionComment.fromJson(String source) =>
  //     DiscussionComment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DiscussionComment(discussionId: $discussionId, comment: $comment, author: $author, createdAt: $createdAt)';
  }

  @override
  List<Object?> get props => [discussionId, comment, author, createdAt];
}
