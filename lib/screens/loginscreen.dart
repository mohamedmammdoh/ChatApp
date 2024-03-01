import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/custombutton.dart';
import 'package:chat_app/widgets/customtextformfield.dart';
import 'package:chat_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    customtextformfield(
                      onchanged: (data) {
                        email = data;
                      },
                      hint_text: 'enter your email',
                      label_text: 'Email Address',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please change your email';
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    customtextformfield(
                      obsuretext: true,
                      onchanged: (data) {
                        password = data;
                      },
                      hint_text: 'enter your password',
                      label_text: 'Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please change your password';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    custombutton(
                      textbutton: 'Login',
                      ontap: () async {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            await login_user();
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(
                              context,
                              'chatscreen',
                              arguments: email,
                            );
                          } on FirebaseAuthException catch (ex) {
                            if (ex.code == 'user-not-found') {
                              // ignore: use_build_context_synchronously
                              showsnackbar(context, 'user your found');
                            } else if (ex.code == 'wrong-password') {
                              // ignore: use_build_context_synchronously
                              showsnackbar(context,
                                  'worng password provided your user!');
                            }
                          } catch (ex) {
                            // ignore: use_build_context_synchronously
                            showsnackbar(context, 'error');
                          }
                          setState(() {
                            isloading = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account ? ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'SignupScreen',
                            );
                          },
                          child: const Text(
                            'Register',
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

  Future<void> login_user() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
