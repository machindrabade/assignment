import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/Home_page.dart';
import '../Screens/login/login.dart';
import '../model/user.dart';
import '../services/user_database.dart';

class UserController {
  final LoginScreen loginScreen = LoginScreen();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<bool> registerUser(
      BuildContext context, String email, String password) async {
    try {
      OurUser user = OurUser();
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? u = authResult.user;
      if (u != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>  HomePage()));
      }
      if (authResult.user != null) {
        user.uid = authResult.user!.uid;
        user.email = authResult.user!.email;
        user.password = password;
        firestore.collection("users").doc(authResult.user!.uid).set({
          "uid": user.uid,
          "email": user.email,
          "password": user.password,
          "userName": user.userName,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginUser(
      BuildContext context, String email, String password) async {
    try {
      UserCredential loginResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = loginResult.user;
      if (user != null) {
        await UserDataBase().getUserInfo();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message ?? '');
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.code),
            ],
          ),
        ),
      );

      return false;
    } finally {
      loginScreen.btnController.stop();
    }
  }
}