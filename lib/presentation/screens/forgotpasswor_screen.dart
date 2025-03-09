import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../presentation/controllers/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botón de regreso
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Iconsax.arrow_left, size: 28),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  const Text("Recuperar contraseña",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 20),

              // Campo de entrada para la cédula
              TextField(
                controller: controller.cedulaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Ingrese su cédula",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                  "Le enviaremos un enlace para restablecer su contraseña",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),

              // Botón de enviar
              ElevatedButton(
                onPressed: controller.resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Enviar",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
