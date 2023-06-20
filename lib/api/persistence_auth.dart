import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isabel/routes.dart';

class PersistenceAuth extends StatefulWidget {
  const PersistenceAuth({super.key});

  @override
  State<PersistenceAuth> createState() => _PersistenceAuthState();
}

class _PersistenceAuthState extends State<PersistenceAuth> {
  bool isPersistence = true, page = false;

  isAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
        page = false;
      } else {
        debugPrint('User is signed in!');
        page = true;
      }
      if (isPersistence) {
        debugPrint("isPersistence");
        isPersistence = false;
        if (page) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.drawerPage, (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.signinPage, (route) => false);
        }
      }
    });
  }

  @override
  void initState() {
    isAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Image(
          image: AssetImage('assets/logo.jpeg'),
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
