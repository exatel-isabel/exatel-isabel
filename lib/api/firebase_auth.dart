import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireAuth {
  /// Cadastrar usuario no firebase com e-mail e senha
  Future<String> signup(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains("email-already-in-use")) {
        return "E-mail já cadastrado";
      }
    }
    return "";
  }

  /// Login de usuario no firebase com e-mail e senha
  Future<String> signin(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains("user-not-found")) {
        return "E-mail não cadastrado!";
      } else if (e.message!.contains("wrong-password")) {
        return "Senha errada!";
      }
    }
    return "";
  }

  /// Verifica o usuario
  int verificarUser() {
    int res = 0;
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
        res++;
      } else {
        debugPrint('User is signed in!');
        res += 2;
      }
    });
    return res;
  }
}

extension EmailValidator on String {
  bool get isNotEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
