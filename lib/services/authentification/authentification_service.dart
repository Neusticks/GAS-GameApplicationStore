import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/reauth_exceptions.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:gas_gameappstore/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:gas_gameappstore/services/database/user_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthentificationService {
  static const String USER_NOT_FOUND_EXCEPTION_CODE = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION_CODE = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION_CODE =
      "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION_CODE =
      "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION_CODE = "weak-password";
  static const String USER_MISMATCH_EXCEPTION_CODE = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION_CODE = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION_CODE = "invalid-email";
  static const String USER_DISABLED_EXCEPTION_CODE = "user-banned";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION_CODE =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION_CODE =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION_CODE =
      "requires-recent-login";

  FirebaseAuth _firebaseAuth;

  AuthentificationService._privateConstructor();
  static AuthentificationService _instance =
  AuthentificationService._privateConstructor();

  FirebaseAuth get firebaseAuth {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth;
  }

  factory AuthentificationService() {
    return _instance;
  }

  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();

  Stream<User> get userChanges => firebaseAuth.userChanges();

  Future<void> deleteUserAccount() async {
    await currentUser.delete();
    await signOut();
  }

  Future<bool> reauthCurrentUser(password) async {
    try {
      UserCredential userCredential =
      await firebaseAuth.signInWithEmailAndPassword(
          email: currentUser.email, password: password);
      userCredential = await currentUser
          .reauthenticateWithCredential(userCredential.credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == WRONG_PASSWORD_EXCEPTION_CODE) {
        throw FirebaseSignInAuthWrongPasswordException();
      } else {
        throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      throw FirebaseReauthUnknownReasonFailureException(message: e.toString());
    }
    return true;
  }

  Future<String> signIn({String email, String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user.emailVerified ) {
        String uid = userCredential.user.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users')
            .doc(uid)
            .get();
        Map<String, dynamic> docFields = userDoc.data();
        var userRole = docFields["userRole"].toString();
        var userIsBan = docFields["userIsBan"].toString();
        if (userRole == "Pilot") {
          return "pilot";
        }
        if (userIsBan == "false") {
            return "true";
          }
          else if (userIsBan == "true") {
            return FirebaseSignInAuthUserDisabledException().toString();
          }
        } else {
        await userCredential.user.sendEmailVerification();
        return FirebaseSignInAuthUserNotVerifiedException().toString();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case INVALID_EMAIL_EXCEPTION_CODE:
          return FirebaseSignInAuthInvalidEmailException().toString();
          break;
        case USER_DISABLED_EXCEPTION_CODE:
          return FirebaseSignInAuthUserDisabledException().toString();
          break;
        case USER_NOT_FOUND_EXCEPTION_CODE:
          return FirebaseSignInAuthUserNotFoundException().toString();
          break;
        case WRONG_PASSWORD_EXCEPTION_CODE:
          return FirebaseSignInAuthWrongPasswordException().toString();
          break;
        default:
          return FirebaseSignInAuthException(message: e.code).toString();
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> registerPilotUser({String email, String userName, String password, String gender, String dob, String phoneNumber}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user.uid;
      if (userCredential.user.emailVerified == false) {
        await userCredential.user.sendEmailVerification();
      }
      await UserDatabaseHelper().createNewPilot(uid, email, userName, password, gender, dob, phoneNumber);
      return "true";
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case EMAIL_ALREADY_IN_USE_EXCEPTION_CODE:
          return FirebaseSignUpAuthEmailAlreadyInUseException().toString();
          break;
        case INVALID_EMAIL_EXCEPTION_CODE:
          return FirebaseSignUpAuthInvalidEmailException().toString();
          break;
        case OPERATION_NOT_ALLOWED_EXCEPTION_CODE:
          return FirebaseSignUpAuthOperationNotAllowedException().toString();
          break;
        case WEAK_PASSWORD_EXCEPTION_CODE:
          return FirebaseSignUpAuthWeakPasswordException().toString();
          break;
        default:
          return FirebaseSignInAuthException(message: e.code).toString();
          break;
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<String> signUp({String email, String name, String password, String gender, String dob, String phoneNumber}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user.uid;
      if (userCredential.user.emailVerified == false) {
        await userCredential.user.sendEmailVerification();
      }
      await UserDatabaseHelper().createNewUser(uid, email, password, gender, dob, name, phoneNumber);
      return "true";
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case EMAIL_ALREADY_IN_USE_EXCEPTION_CODE:
          return FirebaseSignUpAuthEmailAlreadyInUseException().toString();
          break;
        case INVALID_EMAIL_EXCEPTION_CODE:
          return FirebaseSignUpAuthInvalidEmailException().toString();
          break;
        case OPERATION_NOT_ALLOWED_EXCEPTION_CODE:
          return FirebaseSignUpAuthOperationNotAllowedException().toString();
          break;
        case WEAK_PASSWORD_EXCEPTION_CODE:
          return FirebaseSignUpAuthWeakPasswordException().toString();
          break;
        default:
          return FirebaseSignInAuthException(message: e.code).toString();
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  bool get currentUserVerified {
    currentUser.reload();
    return currentUser.emailVerified;
  }

  Future<void> sendVerificationEmailToCurrentUser() async {
    await firebaseAuth.currentUser.sendEmailVerification();
  }

  User get currentUser {
    return firebaseAuth.currentUser;
  }

  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentUser.updateProfile(displayName: updatedDisplayName);
  }

  Future<String> resetPasswordForEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "true";
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == USER_NOT_FOUND_EXCEPTION_CODE) {
        return FirebaseCredentialActionAuthUserNotFoundException().toString();
      } else {
        return FirebaseCredentialActionAuthException(message: e.code).toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changePasswordForCurrentUser(
      {String oldPassword, @required String newPassword}) async {
    try {
      String isOldPasswordProvidedCorrect = "true";
      if (oldPassword != null) {
        isOldPasswordProvidedCorrect =
        await verifyCurrentUserPassword(oldPassword);
      }
      if (isOldPasswordProvidedCorrect == "true") {
        await firebaseAuth.currentUser.updatePassword(newPassword);
        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case WEAK_PASSWORD_EXCEPTION_CODE:
          throw FirebaseCredentialActionAuthWeakPasswordException();
          break;
        case REQUIRES_RECENT_LOGIN_EXCEPTION_CODE:
          throw FirebaseCredentialActionAuthRequiresRecentLoginException();
          break;
        default:
          throw FirebaseCredentialActionAuthException(message: e.code);
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changeEmailForCurrentUser(
      {String password, String newEmail}) async {
    try {
      String isPasswordProvidedCorrect = "true";
      if (password != null) {
        isPasswordProvidedCorrect = await verifyCurrentUserPassword(password);
      }
      if (isPasswordProvidedCorrect == "true") {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
        final userDocSnapshot = FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
        userDocSnapshot.update({"userEmail" : newEmail.toString()});
        return true;
      } else {
        throw FirebaseReauthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw FirebaseCredentialActionAuthException(message: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verifyCurrentUserPassword(String password) async {
    try {
      final AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUser.email,
        password: password,
      );

      final authCredentials =
      await currentUser.reauthenticateWithCredential(authCredential);
      if(authCredentials != null) return "true";
      return "false";
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case USER_MISMATCH_EXCEPTION_CODE:
          return FirebaseReauthUserMismatchException().toString();
          break;
        case USER_NOT_FOUND_EXCEPTION_CODE:
          return FirebaseReauthUserNotFoundException().toString();
          break;
        case INVALID_CREDENTIALS_EXCEPTION_CODE:
          return FirebaseReauthInvalidCredentialException().toString();
          break;
        case INVALID_EMAIL_EXCEPTION_CODE:
          return FirebaseReauthInvalidEmailException().toString();
          break;
        case WRONG_PASSWORD_EXCEPTION_CODE:
          return FirebaseReauthWrongPasswordException().toString();
          break;
        case INVALID_VERIFICATION_CODE_EXCEPTION_CODE:
          return FirebaseReauthInvalidVerificationCodeException().toString();
          break;
        case INVALID_VERIFICATION_ID_EXCEPTION_CODE:
          return FirebaseReauthInvalidVerificationIdException().toString();
          break;
        default:
          return FirebaseReauthException(message: e.code).toString();
          break;
      }
    } catch (e) {
      rethrow;
    }
  }
}
