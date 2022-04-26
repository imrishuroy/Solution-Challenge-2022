import 'package:cloud_firestore/cloud_firestore.dart';
import '/config/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/profile/base_profile_repo.dart';

class ProfileRepository extends BaseProfileRepo {
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<AppUser?> getUserProfile({
    required String? userId,
  }) async {
    try {
      if (userId == null) {
        return null;
      }
      final userSnap =
          await _firestore.collection(Paths.users).doc(userId).get();

      return AppUser.fromDocument(userSnap);
    } catch (error) {
      print('Error in getting user profile ${error.toString()}');

      throw const Failure(message: 'Error in getting user profile');
    }
  }
}
