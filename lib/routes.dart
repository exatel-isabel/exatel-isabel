import 'package:flutter/material.dart';
import 'package:isabel/api/persistence_auth.dart';
import 'package:isabel/drawer.dart';
import 'package:isabel/pages/CRUD/new_password.dart';
import 'package:isabel/pages/CRUD/signin.dart';
import 'package:isabel/pages/CRUD/signup.dart';

class Routes {
  static const String signupPage = "/signup";
  static const String signinPage = "/signin";
  static const String drawerPage = "/drawer";
  static const String newPasswordPage = "/newpassword";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const PersistenceAuth());
      case signinPage:
        return MaterialPageRoute(builder: (_) => const SigninPage());
      case signupPage:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case drawerPage:
        return MaterialPageRoute(builder: (_) => const DrawerPage());
      case newPasswordPage:
        return MaterialPageRoute(builder: (_) => const NewPasswordPage());
      default:
        _erroRota();
    }
    return null;
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}
