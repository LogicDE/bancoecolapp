import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/auth_controller.dart';

class SignUpController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  TextEditingController cedulaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  void signUp() async {
    String cedula = cedulaController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (cedula.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Todos los campos son obligatorios",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;

    await authController.signUp(cedula, email, password);
    isLoading.value = false;
  }

  @override
  void onClose() {
    cedulaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
