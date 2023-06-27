import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isabel/routes.dart';

class PersistenceAuth extends StatefulWidget {
  const PersistenceAuth({super.key});

  @override
  State<PersistenceAuth> createState() => _PersistenceAuthState();
}

class _PersistenceAuthState extends State<PersistenceAuth> {
  bool isFirst = true;
  isAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (isFirst) {
        isFirst = false;
        if (user != null) {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => isAuth());
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
