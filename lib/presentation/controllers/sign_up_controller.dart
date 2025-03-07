import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/auth_controller.dart';

class SignUpController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  void signUp() async {
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Todos los campos son obligatorios",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      await authController.signUp(email, password);
      Get.snackbar("Éxito", "Cuenta creada correctamente",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      Get.offAllNamed('/home'); // Redirige al usuario a la pantalla principal
    } catch (e) {
      Get.snackbar("Error", "No se pudo crear la cuenta",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
