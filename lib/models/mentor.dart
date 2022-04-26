import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';

import '/models/app_user.dart';

class Mentor extends Equatable {
  final AppUser? user;
  final String? degree;
  final List<String?> interests;
  final String? about;
  final String? linkedin;
  final String? github;
  final String? twitter;
  final String? website;
  final String? reason;
  final String? phNo;

  const Mentor({
    required this.user,
    this.degree,
    required this.interests,
    this.about,
    this.linkedin,
    this.github,
    this.twitter,
    this.website,
    this.reason,
    this.phNo,
  });

  Mentor copyWith({
    AppUser? user,
    String? degree,
    List<String?>? interests,
    String? bio,
    String? about,
    String? linkedin,
    String? github,
    String? twitter,
    String? website,
    String? reason,
    String? phNo,
  }) {
    return Mentor(
      user: user ?? this.user,
      degree: degree ?? this.degree,
      interests: interests ?? this.interests,
      about: about ?? this.about,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      twitter: twitter ?? this.twitter,
      website: website ?? this.website,
      reason: reason ?? this.reason,
      phNo: phNo ?? this.phNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phNo': phNo,
      'user': FirebaseFirestore.instance.collection(Paths.users).doc(user?.uid),
      'degree': degree,
      'interests': interests,
      'about': about,
      'linkedin': linkedin,
      'github': github,
      'twitter': twitter,
      'website': website,
      'reason': reason,
    };
  }

  // factory Mentor.fromMap(Map<String, dynamic> map) {
  //   return Mentor(
  //     // user: AppUser.fromMap(map['user']),
  //     degree: map['degree'],
  //     interests: List<String?>.from(map['interests']),
  //     about: map['about'],
  //     linkedin: map['linkedin'],
  //     github: map['github'],
  //     twitter: map['twitter'],
  //     website: map['website'] ?? '',
  //     reason: map['reason'],
  //   );
  // }

  static Future<Mentor?> fromDocument(DocumentSnapshot? doc) async {
    final data = doc?.data() as Map?;
    print('Mentors data doc  --- $data');

    if (data == null) {
      return null;
    }

    final userRef = data['user'] as DocumentReference?;

    final userSnap = await userRef?.get();

    return Mentor(
      phNo: data['phNo'],
      user: AppUser.fromDocument(userSnap),
      interests: data['interests'] != null
          ? List<String?>.from(data['interests'])
          : [],
      website: data['website'],
      degree: data['degree'],
      about: data['about'],
      linkedin: data['linkedin'],
      github: data['github'],
      twitter: data['twitter'],
      reason: data['reason'],
    );
  }

  String toJson() => json.encode(toMap());

  //factory Mentor.fromJson(String source) => Mentor.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mentor(user: $user, degree: $degree, interests: $interests, about: $about, linkedin: $linkedin, github: $github, twitter: $twitter, website: $website, reason: $reason)';
  }

  @override
  List<Object?> get props {
    return [
      user,
      degree,
      interests,
      about,
      linkedin,
      github,
      twitter,
      website,
      reason,
      phNo,
    ];
  }
}
