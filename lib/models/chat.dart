import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import '/enums/user_type.dart';

class ChatMessage extends Equatable {
  final String? messageContent;
  final UserType? userType;
  final DateTime? createdAt;

  const ChatMessage({
    this.messageContent,
    this.userType,
    this.createdAt,
  });

  ChatMessage copyWith({
    String? messageContent,
    UserType? userType,
    required DateTime? createdAt,
  }) {
    return ChatMessage(
      messageContent: messageContent ?? this.messageContent,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final type = EnumToString.convertToString(userType);
    return {
      'messageContent': messageContent,
      'userType': type,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final ownerType = EnumToString.fromString(UserType.values, map['userType']);
    return ChatMessage(
      messageContent: map['messageContent'],
      userType: ownerType ?? UserType.unknown,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChatMessage(messageContent: $messageContent, messageType: $userType, createdAt: $createdAt)';

  @override
  List<Object?> get props => [messageContent, userType, createdAt];
}
