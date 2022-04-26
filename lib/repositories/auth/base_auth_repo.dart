import '/models/app_user.dart';

abstract class BaseAuthRepository {
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> get currentUser;
  Stream<AppUser?> get onAuthChanges;
  Future<void>? forgotPassword({String? email});
  Future<void> signOut();
}
