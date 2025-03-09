import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/auth_controller.dart';

class ForgotPasswordController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  TextEditingController cedulaController = TextEditingController();
  var isLoading =
      false.obs; // 🔹 Agregar variable reactiva para control de estado

  void resetPassword() async {
    if (isLoading.value) return; // Evitar múltiples solicitudes
    isLoading.value = true;

    try {
      String cedula = cedulaController.text.trim();
      if (cedula.isEmpty) {
        Get.snackbar("Error", "Ingrese una cédula válida",
            backgroundColor: Colors.red);
        return;
      }

      bool success = await authController.resetPassword(cedula);
      if (success) {
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(
            '/sign-in'); // 🔹 Redirigir solo si el correo fue enviado
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo procesar la solicitud",
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
