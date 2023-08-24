import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/signup.dart';
import 'package:note_app/untils/until.dart';
import 'package:note_app/widget/textfiled.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  void login() {
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Until().toastMessage(value.user!.email.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MyHomepage(),
          ),
          (route) => false);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Until().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b1c17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF242922),
        title: const Text("Login"),
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextfiled(
                obscureText: false,
                controller: emailController,
                text: "Email",
                keyboardType: TextInputType.emailAddress,
                validation: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is empty";
                  }
                  return null;
                },
              ),
              AppTextfiled(
                obscureText: true,
                controller: passwordController,
                text: "Password",
                maxLine: 1,
                validation: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "password is empty";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onLongPress: () {
                    logger.e("null");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1b1c17),
                      fixedSize: const Size(350, 50),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey))),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      login();
                    }
                  },
                  child: const Text("Login")),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(" Don't have an account?",style: TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ));
                      },
                      child: const Text("Sign up",style: TextStyle(color: Colors.white,)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
