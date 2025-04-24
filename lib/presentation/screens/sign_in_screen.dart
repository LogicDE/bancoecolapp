import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // LOGO
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  const AssetImage('lib/presentation/images/logoEcolapp.png'),
            ),
            const SizedBox(height: 16),
            // TÍTULOS
            const Text(
              'Bienvenido a EcolApp',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Inicia sesión para continuar',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // CAMPO DE CÉDULA
            TextField(
              controller: controller.cedulaController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Cédula'),
            ),
            const SizedBox(height: 16),

            // CAMPO DE CONTRASEÑA
            Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: _inputDecoration('Contraseña').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed('/forgot-password'),
                child: const Text('¿Olvidaste la contraseña?'),
              ),
            ),
            const SizedBox(height: 16),

            // BOTÓN INICIAR SESIÓN
            Obx(() => ElevatedButton(
                  onPressed: controller.authController.isLoading.value
                      ? null
                      : controller.signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Iniciar Sesión'),
                )),
            const SizedBox(height: 20),

            // DIVISOR
            _dividerWithText('o'),

            const SizedBox(height: 20),

            // BOTÓN TOUCH ID
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.fingerprint),
              label: const Text('Iniciar Sesión con Touch ID'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // REGISTRO
            TextButton(
              onPressed: () => Get.toNamed('/sign-up'),
              child: const Text("¿No tienes cuenta? ¡Regístrate!"),
            ),
          ],
        ),
      ),
    );
  }

  // DECORADOR REUTILIZABLE
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // DIVISOR REUTILIZABLE
  Widget _dividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
