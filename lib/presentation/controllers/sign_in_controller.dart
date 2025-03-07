import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/auth_controller.dart';

class SignInController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signIn() {
    authController.signIn(emailController.text, passwordController.text);
  }
}
