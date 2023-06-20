import 'package:flutter/material.dart';
import 'package:isabel/api/firebase_auth.dart';
import 'package:isabel/routes.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisiblePassword = true, isLoading = false;

  snacks(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  validation() async {
    if (!emailController.text.trim().isNotEmail) {
      snacks("Digite seu e-mail!");
    } else if (passwordController.text.trim().length < 6) {
      snacks("Digite sua senha com 6 ou mais caracteres!");
    } else {
      setState(() {
        isLoading = true;
      });
      await FireAuth()
          .signin(emailController.text.trim(), passwordController.text.trim())
          .then((value) {
        debugPrint("signin-login");
        value == ""
            ? Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.drawerPage, (route) => false)
            : (value == "Senha errada!")
                ? snacks("Senha errada!")
                : snacks("E-mail não cadastrado!");
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Center(
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
                    width: 150,
                    height: 150,
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
                    obscureText: isVisiblePassword,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      ),
                      labelText: "Senha",
                      suffixIcon: IconButton(
                        icon: Icon(isVisiblePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isVisiblePassword = !isVisiblePassword;
                          });
                        },
                        color: Colors.blue,
                      ),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
      ),
    );
  }
}
