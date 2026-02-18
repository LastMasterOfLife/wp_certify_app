import 'package:flutter/material.dart';
import 'package:wp_app/Screens/CameraScreen.dart';
import 'package:wp_app/Screens/ContainerScreen.dart';
import 'package:wp_app/Screens/LoginScreen.dart';
import 'package:wp_app/Screens/RegisterScreen.dart';
import 'package:wp_app/Screens/SettingsScreen.dart';
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
        '/container': (context) => Containerscreen(),
        '/web': (context) => Webscreen(loadUrl: 'https://google.com',),
        '/signup': (context) => Registerscreen(),
        '/camera': (context) => CameraScreen(url: 'https://google.com',),
        '/settings': (context) => Settingsscreen(),
      },
    );
  }
}