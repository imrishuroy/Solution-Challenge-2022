import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/app_user.dart';
import '/models/mentee.dart';
import '/models/failure.dart';
import '/config/paths.dart';
import '/models/mentor.dart';
import 'base_mentor_connect_repo.dart';

class MentorConnectRepository extends BaseMentorRepository {
  final FirebaseFirestore _firestore;

  MentorConnectRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String?> getMenteesMentorId({required String? menteeId}) async {
    try {
      final querySnaps = await _firestore
          .collection(Paths.mentees)
          .doc(menteeId)
          .collection(Paths.mentors)
          .get();

      return querySnaps.docs.first.id;
    } catch (error) {
      print('Error in getting mentees mentor');
      throw const Failure(message: 'Error in getting mentees mentor');
    }
  }

  Future<void> connect({
    required String? menteeId,
    required String? mentorId,
    required Mentee? mentee,
  }) async {
    try {
      if (mentorId == null || menteeId == null || mentee == null) {
        return;
      }

      print('THsi  russaalmlala 2');
      await _firestore.collection(Paths.mentees).doc(menteeId).set(
          mentee.copyWith(connectedMentor: AppUser(uid: mentorId)).toMap());

      await _firestore
          .collection(Paths.mentees)
          .doc(menteeId)
          .collection(Paths.mentors)
          .doc(mentorId)
          .set({});

      await _firestore
          .collection(Paths.mentors)
          .doc(mentorId)
          .collection(Paths.mentees)
          .doc(menteeId)
          .set({});
    } catch (error) {
      print('Error in connecting ${error.toString()}');
      throw const Failure(message: 'Error in connecting');
    }
  }

  Future<void> deleteConnection({
    required String? menteeId,
    required String? mentorId,
    required Mentee? mentee,
  }) async {
    try {
      if (mentorId == null || menteeId == null || mentee == null) {
        return;
      }
      print('THis rsaaa');
      print('Mentee id $menteeId');
      await _firestore
          .collection(Paths.mentees)
          .doc(menteeId)
          .set(mentee.copyWith(connectedMentor: null).toMap());

      await _firestore
          .collection(Paths.mentees)
          .doc(menteeId)
          .collection(Paths.mentors)
          .doc(mentorId)
          .delete();

      await _firestore
          .collection(Paths.mentors)
          .doc(mentorId)
          .collection(Paths.mentees)
          .doc(menteeId)
          .delete();
    } catch (error) {
      print('Error in cancel connection ${error.toString()}');
      throw const Failure(message: 'Error in cancel connection');
    }
  }

  Future<void> createMentor({required Mentor? mentor}) async {
    try {
      //  When adding interests/skills,
      //the list should be soreted and entries should in small letters
      if (mentor == null) {
        return;
      }
      await _firestore
          .collection(Paths.mentors)
          .doc(mentor.user?.uid)
          .set(mentor.toMap());
    } catch (error) {
      print('Error creating mentor ${error.toString()}');
    }
  }

  Future<void> createMentee({required Mentee? mentee}) async {
    try {
      //  When adding interests/skills,
      //the list should be soreted and entries should in small letters
      if (mentee == null) {
        return;
      }
      await _firestore
          .collection(Paths.mentees)
          .doc(mentee.user?.uid)
          .set(mentee.toMap());
    } catch (error) {
      print('Error creating mentor ${error.toString()}');
    }
  }

  Future<Mentee?> getMentee({required String? menteeId}) async {
    try {
      final menteeSnap =
          await _firestore.collection(Paths.mentees).doc(menteeId).get();

      return await Mentee.fromDocument(menteeSnap);
    } catch (error) {
      print('Error in getting  mentee ${error.toString()}');
      throw const Failure(message: 'Error getting mentee');
    }
  }

  Future<Mentor?> getMentor({required String? mentorId}) async {
    try {
      final menteeSnap =
          await _firestore.collection(Paths.mentors).doc(mentorId).get();

      return await Mentor.fromDocument(menteeSnap);
    } catch (error) {
      print('Error in getting  mentee ${error.toString()}');
      throw const Failure(message: 'Error getting mentee');
    }
  }

  Future<List<Future<Mentor?>>> getMentorsSugestions(
      {required Mentee? mentee}) async {
    try {
      print('Mentee interessts -- ${mentee?.interests}');
      final querySnaps = await _firestore
          .collection(Paths.mentors)
          .where('interests', isGreaterThanOrEqualTo: mentee?.interests ?? [])
          .get();
      //.where('interests', isGreaterThanOrEqualTo: ['java', 'ml']).get();

      print('mentors suggestions ${querySnaps.docs.length}');

      // for (var element in querySnaps.docs) {
      //   print('mentor suggestions -- ${element.id}');
      //   print('mentor suggestions ${element.data()}');
      // }

      return querySnaps.docs.map((doc) => Mentor.fromDocument(doc)).toList();

      // querySnaps.docs.map((doc) => print('Mentors ${doc.id}'));
    } catch (error) {
      print('Error getting mentors ${error.toString()}');
      throw const Failure(message: 'Error getting mentors ');
    }
  }

  Future<List<Future<Mentee?>>> getSuggestedMentee(
      {required Mentor? mentor}) async {
    try {
      final menteeSnaps = await _firestore
          .collection(Paths.mentees)
          .where('interests', isGreaterThanOrEqualTo: mentor?.interests ?? [])
          .get();

      // final menteeSnaps = await _firestore
      //     .collection(Paths.mentors)
      //     .doc(mentor?.user?.uid)
      //     .collection(Paths.mentees)

      //     // .withConverter<Future<Mentee>>(fromFirestore: (snapshot, _)async=> await Mentee.fromDocument(snapshot), toFirestore: (snapshot, _)=> snapshot);
      //     .get();

      return menteeSnaps.docs.map((doc) => Mentee.fromDocument(doc)).toList();

      // return menteeSnaps.docs.map((doc) async {
      //   print('Metteee doc --- ${doc.id}');

      //   final menteeRef = _firestore.collection(Paths.mentees).doc(doc.id);
      //   print('Mentee from doc ${await menteeRef.get()}');
      //   return Mentee.fromDocument(await menteeRef.get());
      // }).toList();

      // return menteeSnaps.docs
      //     .map((doc) => Mentee.fromDocument(doc.data()))
      //     .toList();
    } catch (error) {
      print('Error getting suggested mentee ${error.toString()}');
      throw const Failure(message: 'Error getting mentee');
    }
  }

  Future<void> connectMentor({
    required String? mentorId,
    required String? menteeId,
  }) async {
    try {
      if (menteeId == null || mentorId == null) {
        return;
      }

      await _firestore
          .collection(Paths.mentees)
          .doc(menteeId)
          .collection(Paths.mentors)
          .doc(mentorId)
          .set({'mentor': _firestore.collection(Paths.mentors).doc(mentorId)});

      await _firestore
          .collection(Paths.mentors)
          .doc(mentorId)
          .collection(Paths.mentees)
          .doc(menteeId)
          .set({'mentor': _firestore.collection(Paths.mentees).doc(menteeId)});
    } catch (error) {
      print('Error in connecting mentor ${error.toString()}');
      throw const Failure(message: 'Error connecting to mentor');
    }
  }
}
