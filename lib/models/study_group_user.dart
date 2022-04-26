import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';

import '/models/app_user.dart';

class StudyGroupUser extends Equatable {
  final AppUser? user;
  final String? degree;
  final List<String?> interests;

  const StudyGroupUser({
    this.user,
    this.degree,
    required this.interests,
  });

  StudyGroupUser copyWith({
    AppUser? user,
    String? degree,
    List<String?>? interests,
  }) {
    return StudyGroupUser(
      user: user ?? this.user,
      degree: degree ?? this.degree,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': FirebaseFirestore.instance.collection(Paths.users).doc(user?.uid),
      'degree': degree,
      'interests': interests,
    };
  }

  static Future<StudyGroupUser?> fromDocument(DocumentSnapshot snap) async {
    final data = snap.data() as Map?;
    if (data != null) {
      final userRef = data['user'] as DocumentReference?;
      final userSnap = await userRef?.get();

      // final buddyRef = data['connectedBuddy'] as DocumentReference?;

      //final buddySnap = await buddyRef?.get();

      return StudyGroupUser(
        user: userSnap != null ? AppUser.fromDocument(userSnap) : null,
        degree: data['degree'],
        interests: data['interests'] != null
            ? List<String?>.from(data['interests'])
            : [],

        // connectedBuddy:
        //     buddySnap != null ? AppUser.fromDocument(buddySnap) : null,
      );
    }
    return null;
  }

  static Future<StudyGroupUser?> fromMap(Map<String, dynamic> map) async {
    final userRef = map['user'] as DocumentReference?;
    final userSnap = await userRef?.get();
    //  final buddyRef = map['connectedBuddy'] as DocumentReference?;

    // final buddySnap = await buddyRef?.get();

    return StudyGroupUser(
      user: userSnap != null ? AppUser.fromDocument(userSnap) : null,
      degree: map['degree'],
      interests: List<String?>.from(
        map['interests'],
      ),

      // connectedBuddy:
      //     buddySnap != null ? AppUser.fromDocument(buddySnap) : null,
    );
  }

  @override
  String toString() =>
      'StudyBuddy(user: $user, degree: $degree, interests: $interests)';

  @override
  List<Object?> get props => [user, degree, interests];
}
