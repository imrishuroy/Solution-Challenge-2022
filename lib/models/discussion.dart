import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';

import '/models/app_user.dart';

class Discussion extends Equatable {
  final String? topicId;
  final String? discussionId;
  final String? title;
  final String? description;
  final List<AppUser?> users;
  final AppUser? author;

  const Discussion({
    this.topicId,
    this.discussionId,
    required this.title,
    required this.description,
    this.users = const [],
    this.author,
  });

  Discussion copyWith({
    String? topicId,
    String? discussionId,
    String? title,
    String? description,
    List<AppUser?>? users,
    AppUser? author,
  }) {
    return Discussion(
      topicId: topicId ?? this.topicId,
      discussionId: discussionId ?? this.discussionId,
      title: title ?? this.title,
      description: description ?? this.description,
      users: users ?? this.users,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'discussionId': discussionId,
      'title': title,
      'description': description,
      'users': users.map((x) => x?.toMap()).toList(),
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author?.uid),
    };
  }

  static Future<Discussion?> fromDocument({
    required QueryDocumentSnapshot? doc,
  }) async {
    final data = doc?.data() as Map?;
    if (data == null) {
      return null;
    }
    final authorRef = data['author'] as DocumentReference?;
    final authorSnap = await authorRef?.get();

    print('DiscussioId --- ${doc?.id}');

    // final _firebase = FirebaseFirestore.instance;

    // final discussionRef = FirebaseFirestore.instance
    //     .collection(Paths.discussionUsers)
    //     .doc(doc?.id);

    return Discussion(
      topicId: data['topicId'],
      discussionId: doc?.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      // users: data['users'] != null
      //     ? List<AppUser?>.from(data['users']?.map((x) => AppUser.fromMap(x)))
      //     : [],
      author: authorSnap != null ? AppUser.fromDocument(authorSnap) : null,
    );
  }

  // factory Discussion.fromMap(Map<String, dynamic> map) {
  //   final authorRef = map['author'] as DocumentReference?;

  //   return Discussion(
  //     topicId: map['topicId'],
  //     discussionId: map['discussionId'],
  //     title: map['title'] ?? '',
  //     description: map['description'] ?? '',
  //     users: map['users'] != null
  //         ? List<AppUser?>.from(map['users']?.map((x) => AppUser.fromMap(x)))
  //         : [],
  //     author: map['author'],
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Discussion.fromJson(String source) =>
  //     Discussion.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Discussion(topicId: $topicId, discussionId: $discussionId, title: $title, description: $description, users: $users, author: $author)';
  }

  @override
  List<Object?> get props {
    return [
      topicId,
      discussionId,
      title,
      description,
      users,
      author,
    ];
  }

  factory Discussion.fromMap(Map<String, dynamic> map) {
    return Discussion(
      topicId: map['topicId'],
      discussionId: map['discussionId'],
      title: map['title'],
      description: map['description'],
      users: List<AppUser?>.from(map['users']?.map((x) => AppUser.fromMap(x))),
      author: map['author'] != null ? AppUser.fromMap(map['author']) : null,
    );
  }

  factory Discussion.fromJson(String source) =>
      Discussion.fromMap(json.decode(source));
}
