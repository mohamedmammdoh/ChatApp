import 'dart:math';

import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custombutton.dart';
import 'package:chat_app/widgets/customtextformfield.dart';
import 'package:chat_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? email;

  String? password;

  GlobalKey<FormState> formkey = GlobalKey();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: kprimarycolor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Image.asset(
                        'assest/scholar.png',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text(
                        'Scholar Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'pacifico',
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    customtextformfield(
                      hint_text: 'enter your email',
                      label_text: 'Email Address',
                      onchanged: (data) {
                        email = data;
                      },
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'please change your email';
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    customtextformfield(
                      hint_text: 'enter your password',
                      label_text: 'Password',
                      onchanged: (data) {
                        password = data;
                      },
                      validator: (data) {
                        if (data!.isEmpty) {
                          return 'please change your password';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    custombutton(
                      textbutton: 'Register',
                      ontap: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            await register_user();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(
                              context,
                              'chatscreen',
                              arguments: email,
                            );
                          } on FirebaseAuthException catch (ex) {
                            if (ex.code == 'weak-password') {
                              // ignore: use_build_context_synchronously
                              showsnackbar(context, 'weak-password');
                            } else if (ex.code == 'email-already-in-use') {
                              // ignore: use_build_context_synchronously
                              showsnackbar(
                                  context, 'The  Email to use is already!');
                            }
                          } catch (ex) {
                            // ignore: use_build_context_synchronously
                            showsnackbar(context, 'error');
                          }

                          setState(() {
                            isloading = false;
                          });
                        } else {}
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already I have account !',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register_user() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
