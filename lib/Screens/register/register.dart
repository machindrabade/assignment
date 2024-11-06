
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../components/background.dart';
import '../../controller/user_controller.dart';
import '../../services/registerservices.dart';
import '../login/login.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({
    super.key,
  });
  final RoundedLoadingButtonController _btnController =
  RoundedLoadingButtonController();
  final RegisterServices registerServices = RegisterServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "SignUp",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextField(
                  controller: registerServices.emailController,
                  onChanged: (value) => registerServices.updateController(
                      registerServices.emailController, value),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: registerServices.passwordController,
                  onChanged: (value) => registerServices.updateController(
                      registerServices.passwordController, value),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: registerServices.confirmpasswordController,
                  onChanged: (value) => registerServices.updateController(
                      registerServices.confirmpasswordController, value),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Re-Password"),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedLoadingButton(
                    controller: _btnController,
                    onPressed: () {
                      if (registerServices.passwordController.text ==
                          registerServices.confirmpasswordController.text) {
                        UserController().registerUser(
                            context,
                            registerServices.emailController.text,
                            registerServices.passwordController.text);
                      } else {
                        AchievementView(
                            title: "ERROR",
                            subTitle: "Password does not match",
                            color: Colors.red.shade100,
                            duration: const Duration(milliseconds: 200))
                            .show(context);
                      }
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontSize: 16),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}