import 'package:flutter/material.dart';
import 'package:isabel/pages/login.dart';
import 'package:isabel/pages/signup.dart';

class Routes {
  static const String signupPage = "/signup";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signupPage:
        return MaterialPageRoute(builder: (_) => const SignupPage());
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
