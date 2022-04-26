import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StudyGroup extends Equatable {
  final String? name;
  final String? groupId;
  final String? description;
  final List<String?> domains;

  const StudyGroup({
    this.name,
    this.groupId,
    this.description,
    required this.domains,
  });

  StudyGroup copyWith({
    String? name,
    String? groupId,
    String? description,
    List<String?>? domains,
  }) {
    return StudyGroup(
      name: name ?? this.name,
      description: description ?? this.description,
      domains: domains ?? this.domains,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'domains': domains,
    };
  }

  factory StudyGroup.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map?;

    return StudyGroup(
      groupId: doc.id,
      name: data?['name'],
      description: data?['description'],
      domains: List<String?>.from(data?['domains']),
    );
  }

  factory StudyGroup.fromMap(Map<String, dynamic> map) {
    return StudyGroup(
      groupId: map['groupId'],
      name: map['name'],
      description: map['description'],
      domains: List<String?>.from(map['domains']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StudyGroup.fromJson(String source) =>
      StudyGroup.fromMap(json.decode(source));

  @override
  String toString() =>
      'StudyGroup(name: $name, description: $description, domains: $domains)';

  @override
  List<Object?> get props => [name, description, domains, groupId];
}
