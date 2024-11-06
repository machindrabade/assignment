import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Home_page.dart';
import 'Screens/login/login.dart';
import 'Screens/register/register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are initialized
  await Firebase.initializeApp();
  runApp(MyApp());
  print("firebase initilised");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2661FA),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),//RegisterScreen(),
    );
  }
}