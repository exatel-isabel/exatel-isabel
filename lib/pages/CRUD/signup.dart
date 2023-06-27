import 'package:flutter/material.dart';
import 'package:isabel/api/firebase_auth.dart';
import 'package:isabel/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  snacks(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  validation() async {
    if (!emailController.text.trim().isNotEmail) {
      snacks("E-mail invalido!");
    } else if (passwordController.text.trim().length < 6) {
      snacks("Senha deve conter pelo menos 6 caracteres!");
    } else {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      await FireAuth()
          .signup(emailController.text.trim(), passwordController.text.trim())
          .then((value) {
        if (value == "") {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.signinPage, (route) => false);
          snacks("Faça login novamente!");
        } else {
          snacks("E-mail já cadastrado");
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: (Theme.of(context).platform == TargetPlatform.android)
                  ? 120
                  : 50,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: (Theme.of(context).platform == TargetPlatform.android)
                  ? MediaQuery.of(context).size.height - 120
                  : MediaQuery.of(context).size.height - 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: FractionallySizedBox(
                widthFactor:
                    (Theme.of(context).platform == TargetPlatform.android)
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
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                        labelText: "E-mail",
                        prefixIcon: const Icon(
                          Icons.people,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      onFieldSubmitted: (value) => validation(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.normal,
                        ),
                        labelText: "Senha",
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => validation(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
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
          ],
        ),
      ),
    );
  }
}
