import 'package:flutter/material.dart';
import 'package:isabel/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisiblePassword = true, isAuth = false;

  snacks(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  validation() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        !emailController.text.contains('@')) {
      snacks("E-mail e Senha inválidos!");
    } else {
      // fazer login
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
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                child: Image(
                  image: AssetImage('assets/logo.jpeg'),
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 15),
              Flexible(
                child: TextFormField(
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
              ),
              const SizedBox(height: 15),
              Flexible(
                child: TextFormField(
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
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.black,
                      value: isAuth,
                      onChanged: (value) {
                        setState(() {
                          isAuth = !isAuth;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    const Text("Manter-me conectado"),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Esqueci-me a senha",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => validation(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text("-------- ou --------"),
              const SizedBox(height: 15),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                          Routes.signupPage, (route) => false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Cadastre-se",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
