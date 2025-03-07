import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/auth_controller.dart';

class ForgotPasswordController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar("Error", "Enter a valid email address",
          backgroundColor: Colors.red);
      return;
    }

    bool success = await authController.resetPassword(email);

    if (success) {
      Get.snackbar("Success", "Password reset link sent to $email");

      // 🔹 Redirigir al usuario al Sign-In después de 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed('/sign-in'); // Si usas rutas nombradas
        // Get.off(() => SignInPage());  // Si navegas sin rutas nombradas
      });
    } else {
      Get.snackbar("Error", "Failed to send password reset email",
          backgroundColor: Colors.red);
    }
  }
}
