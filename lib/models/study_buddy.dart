import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';

import '/models/app_user.dart';

class StudyBuddy extends Equatable {
  final AppUser? user;
  final String? degree;
  final List<String?> interests;
  final String? connectedBuddy;

  const StudyBuddy({
    this.user,
    this.degree,
    required this.interests,
    this.connectedBuddy,
  });

  StudyBuddy copyWith({
    AppUser? user,
    String? degree,
    List<String?>? interests,
    String? connectedBuddy,
  }) {
    return StudyBuddy(
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
      'connectedBuddy': connectedBuddy,
    };
  }

  static Future<StudyBuddy?> fromDoccument(DocumentSnapshot snap) async {
    final data = snap.data() as Map?;
    if (data != null) {
      final userRef = data['user'] as DocumentReference?;
      final userSnap = await userRef?.get();

      // final buddyRef = data['connectedBuddy'] as DocumentReference?;

      //final buddySnap = await buddyRef?.get();

      return StudyBuddy(
          user: userSnap != null ? AppUser.fromDocument(userSnap) : null,
          degree: data['degree'],
          interests: data['interests'] != null
              ? List<String?>.from(data['interests'])
              : [],
          connectedBuddy: data['connectedBuddy']
          // connectedBuddy:
          //     buddySnap != null ? AppUser.fromDocument(buddySnap) : null,
          );
    }
    return null;
  }

  static Future<StudyBuddy?> fromMap(Map<String, dynamic> map) async {
    final userRef = map['user'] as DocumentReference?;
    final userSnap = await userRef?.get();
    //  final buddyRef = map['connectedBuddy'] as DocumentReference?;

    // final buddySnap = await buddyRef?.get();

    return StudyBuddy(
        user: userSnap != null ? AppUser.fromDocument(userSnap) : null,
        degree: map['degree'],
        interests: List<String?>.from(
          map['interests'],
        ),
        connectedBuddy: map['connectedBuddy']
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
