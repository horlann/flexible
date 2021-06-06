import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class FireAuthService {
  late FirebaseAuth _firebaseAuth;

  FireAuthService() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  // Basic operations

  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  bool get isAuthenticated {
    return getUser() != null ? true : false;
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  //
  // Auth via email
  //

  Future registrationByMail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return Future.error(e);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return Future.error(e);
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  ///
  // Auth via sms
  ///

  String _verificationCode = "";

  Future verifyPhoneNumber(String phoneNumber) async {
    Completer completer = Completer();

    _smsCodeSent(String verificationCode, List<int> code) {
      print('pho sent');
      this._verificationCode = verificationCode;
      completer.complete();
    }

    _verificationFailed(authException) {
      print('pho failed');
      completer.completeError(authException.toString());
    }

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 0),
        verificationCompleted: (authCredential) => {},
        verificationFailed: (authException) =>
            _verificationFailed(authException),
        codeAutoRetrievalTimeout: (verificationId) => {},
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code!]));

    return completer.future;
  }

  Future<void> signInWithSmsCode(String smsCode) async {
    print('pho ferify');
    AuthCredential authCredential = PhoneAuthProvider.credential(
        smsCode: smsCode, verificationId: _verificationCode);
    await FirebaseAuth.instance.signInWithCredential(authCredential);
  }
}
