import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  Future<UserCredential?> signup(String emailAddress, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e as String?);
    }
    return credential;
  }
}
