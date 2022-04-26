import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  final String? topicId;
  final String title;
  final String labelImg;

  const Topic({
    required this.topicId,
    required this.title,
    required this.labelImg,
  });

  Topic copyWith({
    String? topicId,
    String? title,
    String? labelImg,
  }) {
    return Topic(
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      labelImg: labelImg ?? this.labelImg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'title': title,
      'labelImg': labelImg,
    };
  }

  factory Topic.fromDocument(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map?;
    return Topic(
      topicId: doc.id,
      title: data?['title'],
      labelImg: data?['labelImg'],
    );
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      topicId: map['topicId'],
      title: map['title'] ?? '',
      labelImg: map['labelImg'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Topic.fromJson(String source) => Topic.fromMap(json.decode(source));

  @override
  String toString() =>
      'Topic(topicId: $topicId, title: $title, labelImg: $labelImg)';

  @override
  List<Object?> get props => [topicId, title, labelImg];
}
