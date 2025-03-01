import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signIn() {
    // Aquí puedes agregar la lógica de autenticación
    print("Usuario: ${emailController.text}, Contraseña: ${passwordController.text}");
  }
}
