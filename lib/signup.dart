import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/untils/until.dart';
import 'package:note_app/widget/textfiled.dart';

import 'login.dart';
import 'main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

  }
/*
  void signup(){
    auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text.toString())
        .then((value) => logger.d("Signup Successfully") )
        .catchError((error) => logger.i("Failed $error"));

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),

      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              AppTextfiled(
                obscureText: false,
                controller: emailController,
                text: "Email",
                keyboardType: TextInputType.emailAddress,
                validation: (value) {
                  if(value == null || value.trim().isEmpty ){
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
                  if(value == null || value.trim().isEmpty ){
                    return "password is empty";
                  }
                  return null;

                },
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                  onLongPress: (){
                    print("null");
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(350, 50)),
                  onPressed: ()  {
                    if(formkey.currentState!.validate()){
                      auth.createUserWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                          .then((value) => logger.d("create account successfully"))
                          .onError((error, stackTrace){
                        Until().toastMessage(error.toString());
                      });
                    }
                    clearText();

                  },
                  child:  const Text("Sign Up")),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(" Joined us before?"),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                  }, child: const Text("Login"))


                ],
              )

            ],
          ),
        ),
      ),

    );
  }

  clearText(){
    emailController.clear();
    passwordController.clear();
  }

}
