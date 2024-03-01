import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/chatscreen.dart';
import 'package:chat_app/screens/loginscreen.dart';
import 'package:chat_app/screens/signupscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChattApp());
}

class ChattApp extends StatefulWidget {
  const ChattApp({super.key});

  @override
  State<ChattApp> createState() => _ChattAppState();
}

class _ChattAppState extends State<ChattApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'LoginScreen',
      routes: {
        'LoginScreen': (context) => LoginScreen(),
        'SignupScreen': (context) => SignupScreen(),
        'chatscreen': (context) => ChattScreen(),
      },
    );
  }
}
