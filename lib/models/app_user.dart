import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/enums/user_type.dart';

class AppUser extends Equatable {
  final String? uid;
  final String? photUrl;
  final String? name;
  final String? phNumber;
  final String? email;

  // final List<String?> interests;
  // final UserType userType;

  const AppUser({
    this.uid,
    this.photUrl,
    this.name,
    this.phNumber,
    this.email,
    // this.skills = const [],
    // this.interests = const [],
    // required this.userType,
  });

  AppUser copyWith({
    String? uid,
    String? photUrl,
    String? name,
    String? phNumber,
    String? email,
    // List<String?>? skills,
    List<String?>? interests,
    UserType? userType,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      photUrl: photUrl ?? this.photUrl,
      name: name ?? this.name,
      phNumber: phNumber ?? this.phNumber,
      email: email ?? this.email,
      // skills: skills ?? this.skills,
      // interests: interests ?? this.interests,
      // userType: userType ?? this.userType,
    );
  }

  static const empty = AppUser(
    uid: '',
    email: '',
    name: '',
  );

  Map<String, dynamic> toMap() {
    //final type = EnumToString.convertToString(userType);
    return {
      'uid': uid,
      'photUrl': photUrl,
      'name': name,
      'phNumber': phNumber,
      'email': email,
      // 'skills': skills,
      // 'interests': interests,
      // 'userType': type
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    // final type = EnumToString.fromString(UserType.values, map['userType']);
    return AppUser(
      uid: map['uid'],
      photUrl: map['photUrl'],
      name: map['name'],
      phNumber: map['phNumber'],
      email: map['email'],
      // skills: List<String?>.from(map['skills']),
      // interests: List<String?>.from(map['interests']),
      // userType: type ?? UserType.unknown,
    );
  }

  factory AppUser.fromDocument(DocumentSnapshot? doc) {
    final data = doc?.data() as Map?;

    // final type = EnumToString.fromString(UserType.values, data?['userType']);
    print('App users ---- $data');
    return AppUser(
      uid: data?['uid'],
      photUrl: data?['photUrl'],
      name: data?['name'],
      phNumber: data?['phNumber'],
      email: data?['email'],
      // skills: List<String?>.from(data?['skills']),
      // interests: List<String?>.from(data?['interests']),
      // userType: type ?? UserType.unknown,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(uid: $uid, photUrl: $photUrl, name: $name, phNumber: $phNumber, email: $email,)';
  }

  @override
  List<Object?> get props {
    return [
      uid,
      photUrl,
      name,
      phNumber,
      email,
      // skills,
      //interests,
      // userType,
    ];
  }
}
