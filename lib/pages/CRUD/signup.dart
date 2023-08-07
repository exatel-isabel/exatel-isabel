import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isabel/apis/firebase_auth.dart';
import 'package:isabel/bugiganga.dart';
import 'package:isabel/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isLoading = false, isLogado = false;

  validation() async {
    if (!emailController.text.trim().isNotEmail) {
      Bugiganga().snacks(context, "E-mail invalido!");
    } else if (passwordController.text.trim().length < 6) {
      Bugiganga().snacks(context, "Senha deve conter pelo menos 6 caracteres!");
    } else if (nameController.text.trim().isEmpty) {
      Bugiganga().snacks(context, "Digite seu Nome e sobrenome!");
    } else {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      await FireAuth()
          .signup(emailController.text.trim(), passwordController.text.trim())
          .then((value) {
        if (value == "") {
          FirebaseAuth.instance.userChanges().listen((User? user) {
            if (!isLogado) {
              isLogado = !isLogado;
              if (user != null) {
                if (user.displayName == null) {
                  user.updateDisplayName(nameController.text.trim());
                }
              }
            }
          });
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.signinPage, (route) => false);
          Bugiganga().snacks(context, "Faça login novamente!");
        } else {
          Bugiganga().snacks(context, "E-mail já cadastrado");
        }
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: FractionallySizedBox(
            widthFactor: (Theme.of(context).platform == TargetPlatform.android)
                ? 0.8
                : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/logo.jpeg'),
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: Bugiganga().textFormFieldDecoration(
                      label: "E-mail", icon: Icons.people),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: Bugiganga().textFormFieldDecoration(
                      label: "Senha", icon: Icons.lock),
                ),
                const SizedBox(height: 15),
                TextFormField(
                    controller: nameController,
                    onFieldSubmitted: (value) => validation(),
                    keyboardType: TextInputType.text,
                    decoration: Bugiganga().textFormFieldDecoration(
                        label: "Nome e sobrenome", icon: Icons.account_circle)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => validation(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "Cadastrar",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
