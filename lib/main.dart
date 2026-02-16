import 'package:flutter/material.dart';
import 'package:wp_app/Screens/LoginScreen.dart';
import 'package:wp_app/Screens/SignUpScreen.dart';
import 'package:wp_app/Screens/WebScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Loginscreen(),
        '/web': (context) => Webscreen(),
        '/signup': (context) => Signupscreen(),
      },
    );
  }
}