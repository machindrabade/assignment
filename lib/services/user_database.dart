import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';


class UserDataBase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();

  Future<bool> createUserInbd(user) async {
    try {
      await firestore.collection("users").add({
        "uid": user.uid,
        "email": user.email,
        "userName": user.userName,
        "password": user.password
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> setUserInfo(String displayName, String email) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
        await userCollection
            .doc(user.uid)
            .set({"uid": user.uid, "displayName": displayName, "email": email});
        print("Info set Successfully");
      } else {
        print("No user is currently signed in");
      }
    } catch (e) {
      print("Error setting user info:$e");
    }
  }

  Future<void> getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      _btnController.start();
      if (user != null) {
        CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
        DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
          print("User Info $userData");
        } else {
          print("user not found");
        }
      } else {
        print("No user is currently signed In");
      }
    } catch (e) {
      print("Error getting user Info: $e");
    } finally {
      _btnController.stop();
    }
  }
}