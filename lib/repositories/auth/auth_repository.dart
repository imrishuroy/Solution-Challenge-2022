import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/config/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';

import 'base_auth_repo.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  AppUser? _appUser(User? user) {
    if (user == null) return null;

    return AppUser(
      uid: user.uid,
      name: user.displayName,
      photUrl: user.photoURL,
      phNumber: user.phoneNumber ?? '',
      email: user.email,
      //  userType: SharedPrefs().getUserType,
    );
  }

  @override
  Stream<AppUser?> get onAuthChanges =>
      _firebaseAuth.userChanges().map((user) => _appUser(user));

  @override
  Future<AppUser?> get currentUser async => _appUser(_firebaseAuth.currentUser);

  String? get userImage => _firebaseAuth.currentUser?.photoURL;

  String? get userId => _firebaseAuth.currentUser?.uid;

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // final user = await _userRef.doc(userCredential.user?.uid).get();

      // print('User Exists ---- ${user.exists}');

      return _appUser(userCredential.user);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      print('Error ${error.toString()}');
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AppUser?> signInWithApple() async {
    try {
// To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return _appUser(userCredential.user);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  Future<AppUser?> loginInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    try {
      if (email != null && password != null) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        return _appUser(userCredential.user);
      }
      return null;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  Future<AppUser?> signUpWithEmailAndPassword(
      {required String? email, required String? password}) async {
    try {
      if (email != null && password != null) {
        final userCredentail = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        return _appUser(userCredentail.user);
      }
      return null;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<void>? forgotPassword({String? email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email!);
    } catch (error) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found',
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }
}
