import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';
import '/models/app_user.dart';

class Mentee extends Equatable {
  final String? phNo;
  final AppUser? user;
  final String? degree;
  final List<String?> interests;
  final String? reason;
  final AppUser? connectedMentor;

  const Mentee({
    this.user,
    required this.phNo,
    this.degree,
    required this.interests,
    this.reason,
    this.connectedMentor,
  });

  Mentee copyWith({
    AppUser? user,
    String? degree,
    List<String?>? interests,
    String? reason,
    AppUser? connectedMentor,
    String? phNo,
  }) {
    return Mentee(
        phNo: phNo ?? this.phNo,
        user: user ?? this.user,
        degree: degree ?? this.degree,
        interests: interests ?? this.interests,
        reason: reason ?? this.reason,
        // connectedMentor: connectedMentor ?? this.connectedMentor,
        connectedMentor: connectedMentor

        ///?? this.connectedMentor,
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'phNo': phNo,
      'user': FirebaseFirestore.instance.collection(Paths.users).doc(user?.uid),
      'degree': degree,
      'interests': interests,
      'reason': reason,
      'connectedMentor': connectedMentor != null
          ? FirebaseFirestore.instance
              .collection(Paths.users)
              .doc(connectedMentor?.uid)
          : null,
    };
  }

  static Future<Mentee?> fromDocument(DocumentSnapshot? doc) async {
    final data = doc?.data() as Map?;
    if (data == null) {
      return null;
    }
    final userRef = data['user'] as DocumentReference?;
    final mentorRef = data['connectedMentor'] as DocumentReference?;
    final userSnap = await userRef?.get();
    final mentorSnap = await mentorRef?.get();

    print('Mentee data -- $data');
    return Mentee(
      phNo: data['phNo'],
      interests: data['interests'] != null
          ? List<String?>.from(data['interests'])
          : [],
      user: data['user'] != null ? AppUser.fromDocument(userSnap) : null,
      reason: data['reason'],
      degree: data['degree'],
      connectedMentor: data['connectedMentor'] != null
          ? AppUser.fromDocument(mentorSnap)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  //factory Mentee.fromJson(String source) => Mentee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Mentee(user: $user, degree: $degree, interests: $interests, reason: $reason, phNo: $phNo)';
  }

  @override
  List<Object?> get props =>
      [user, degree, interests, reason, connectedMentor, phNo];
}
