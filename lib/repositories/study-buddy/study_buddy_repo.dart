import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/study_group.dart';
import '/models/study_group_user.dart';
import '/config/paths.dart';
import '/models/failure.dart';
import '/models/study_buddy.dart';
import '/repositories/study-buddy/base_study_buddy_repo.dart';

class StudyBuddyRepository extends BaseStudyBuddyRepo {
  final FirebaseFirestore _firestore;

  StudyBuddyRepository({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createStudyBuddy({required StudyBuddy buddy}) async {
    try {
      if (buddy.user == null) {
        return;
      }
      await _firestore
          .collection(Paths.studyBuddy)
          .doc(buddy.user?.uid)
          .set(buddy.toMap());
    } catch (error) {
      print('Error in creating study buddy ${error.toString()}');
      throw const Failure(message: 'Error in adding study buddy');
    }
  }

  Future<StudyBuddy?> getCurrentStudyBuddy({required String? userId}) async {
    try {
      if (userId == null) {
        return null;
      }
      final snaps =
          await _firestore.collection(Paths.studyBuddy).doc(userId).get();

      return StudyBuddy.fromDoccument(snaps);
    } catch (error) {
      print('Error in getting current study buddy ${error.toString()}');
      throw const Failure(message: 'Error in getting study buddy');
    }
  }

  Future<List<Future<StudyBuddy?>>> getRecommendedStudyBuddies({
    required StudyBuddy? studyBuddy,
  }) async {
    try {
      if (studyBuddy == null) {
        return [];
      }
      final snaps = await _firestore
          .collection(Paths.studyBuddy)
          .where('interests', isGreaterThanOrEqualTo: studyBuddy.interests)
          .get();

      return snaps.docs
          .map((doc) async => await StudyBuddy.fromMap(doc.data()))
          .toList();
    } catch (error) {
      print('Error in getting current study buddy ${error.toString()}');
      throw const Failure(message: 'Error in getting study buddy');
    }
  }

  Future<void> connectBuddy({
    required String? currentUserId,
    required String? buddyUserId,
  }) async {
    if (currentUserId == null || buddyUserId == null) {
      return;
    }

    try {
      await _firestore
          .collection(Paths.studyBuddy)
          .doc(currentUserId)
          .update({'connectedBuddy': buddyUserId});

      await _firestore
          .collection(Paths.studyBuddy)
          .doc(buddyUserId)
          .update({'connectedBuddy': currentUserId});
    } catch (error) {
      print('Error in connecting buddy ${error.toString()}');
      throw const Failure(message: 'Error in connecing buddy');
    }
  }

  //  Study Group

  Future<void> createUser({required StudyGroupUser? groupUser}) async {
    try {
      if (groupUser == null) {
        return;
      }
      await _firestore
          .collection(Paths.studyGroupUsers)
          .doc(groupUser.user?.uid)
          .set(groupUser.toMap());
    } catch (error) {
      print('Error in creating user ${error.toString()}');
      throw Failure(message: error.toString());
    }
  }

  Future<StudyGroupUser?> getCurrentGroupUser({required String? userId}) async {
    try {
      if (userId == null) {
        return null;
      }
      final userSnap =
          await _firestore.collection(Paths.studyGroupUsers).doc(userId).get();
      return await StudyGroupUser.fromDocument(userSnap);
    } catch (error) {
      print('Error in creating user ${error.toString()}');
      throw Failure(message: error.toString());
    }
  }

  Future<List<StudyGroup?>> getGroupSuggestions(
      {required StudyGroupUser? user}) async {
    try {
      if (user == null) {
        return [];
      }
      print('User interests -- ${user.interests}');
      final groupSnaps = await _firestore
          .collection(Paths.studyGroups)
          .where('domains', isGreaterThanOrEqualTo: user.interests)
          .get();

      return groupSnaps.docs
          .map((doc) => StudyGroup.fromDocument(doc))
          .toList();
    } catch (error) {
      throw const Failure(message: 'Error in getting study group suggestions');
    }
  }

  Future<void> joinGroup({
    required String? groupId,
    required String? studyGroupUserId,
  }) async {
    try {
      if (groupId == null || studyGroupUserId == null) {
        return;
      }
      await _firestore
          .collection(Paths.studyGroups)
          .doc(groupId)
          .collection(Paths.members)
          .doc(studyGroupUserId)
          .set({});

      await _firestore
          .collection(Paths.studyGroupUsers)
          .doc(studyGroupUserId)
          .collection(Paths.studyGroups)
          .doc(groupId)
          .set({});
    } catch (error) {
      print('Error in joining group ${error.toString()}');
      throw const Failure(message: 'Error in joining group');
    }
  }
}
