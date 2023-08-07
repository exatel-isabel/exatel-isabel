import 'package:flutter/material.dart';
import 'package:isabel/apis/firebase_auth.dart';
import 'package:isabel/bugiganga.dart';
import 'package:isabel/routes.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  validation() async {
    if (!emailController.text.trim().isNotEmail) {
      Bugiganga().snacks(context, "E-mail invalido!");
    } else {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      await FireAuth()
          .signin(emailController.text.trim(), "******")
          .then((value) {
        if (value == "Senha errada!") {
          FireAuth().sendEmailPassword(emailController.text.trim());
          Bugiganga().snacks(context,
              "Verifique sua caixa de entrada em ${emailController.text.trim()}");
          Navigator.pop(context);
        } else {
          Navigator.of(context).popAndPushNamed(Routes.signupPage);
          Bugiganga().snacks(context, "E-mail não cadastrado!");
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
                  onFieldSubmitted: (value) => validation(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: Bugiganga().textFormFieldDecoration(
                    label: "E-mail",
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => validation(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "Enviar e-mail",
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
