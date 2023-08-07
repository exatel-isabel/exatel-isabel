import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isabel/providers/funcionario_provider.dart';
import 'package:isabel/routes.dart';
import 'package:provider/provider.dart';

class PersistenceAuthPage extends StatefulWidget {
  const PersistenceAuthPage({super.key});

  @override
  State<PersistenceAuthPage> createState() => _PersistenceAuthPageState();
}

class _PersistenceAuthPageState extends State<PersistenceAuthPage> {
  bool isLogado = false;

  @override
  void initState() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (!isLogado) {
        isLogado = !isLogado;
        if (user != null) {
          context.read<FuncionarioProvider>().addFuncionario(
                user.displayName!,
                user.email!,
              );
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.drawerPage, (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.signinPage, (route) => false);
        }
      }
    });
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
