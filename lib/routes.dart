import 'package:flutter/material.dart';
import 'package:isabel/pages/home.dart';
import 'package:isabel/pages/signin.dart';
import 'package:isabel/pages/signup.dart';

class Routes {
  static const String signupPage = "/signup";
  static const String signinPage = "/signin";
  static const String homePage = "/home";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const SigninPage());
      case signinPage:
        return MaterialPageRoute(builder: (_) => const SigninPage());
      case signupPage:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
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
