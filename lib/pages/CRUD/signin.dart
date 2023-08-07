import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isabel/apis/firebase_auth.dart';
import 'package:isabel/bugiganga.dart';
import 'package:isabel/providers/funcionario_provider.dart';
import 'package:isabel/routes.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisiblePassword = true, isLoading = false, isLogado = false;

  validation() async {
    if (!emailController.text.trim().isNotEmail) {
      Bugiganga().snacks(context, "E-mail invalido!");
    } else if (passwordController.text.trim().length < 6) {
      Bugiganga().snacks(context, "Digite sua senha com 6 ou mais caracteres!");
    } else {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      await FireAuth()
          .signin(emailController.text.trim(), passwordController.text.trim())
          .then((value) {
        if (value == "") {
          FirebaseAuth.instance.userChanges().listen((User? user) {
            if (!isLogado) {
              isLogado = !isLogado;
              if (user != null) {
                context.read<FuncionarioProvider>().addFuncionario(
                      user.displayName!,
                      emailController.text.trim(),
                    );
              }
            }
          });
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.drawerPage, (route) => false);
        } else {
          if (value == "Senha errada!") {
            Bugiganga().snacks(context, "Senha errada!");
          } else {
            Bugiganga().snacks(context, "E-mail não cadastrado!");
          }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    label: "E-mail",
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  onFieldSubmitted: (value) => validation(),
                  keyboardType: TextInputType.text,
                  obscureText: isVisiblePassword,
                  decoration: Bugiganga().textFormFieldDecoration(
                      label: "Senha",
                      icon: Icons.lock,
                      sufix: IconButton(
                        icon: Icon(isVisiblePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isVisiblePassword = !isVisiblePassword;
                          });
                        },
                        color: Colors.blue,
                      )),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(Routes.newPasswordPage),
                      child: const Text(
                        "Esqueci minha senha",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => validation(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 15),
                const Text("-------- ou --------"),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.signupPage),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "Cadastre-se",
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
