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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LOGO DE ECOLAPP
              Image.network(
                'https://i.imgur.com/pZRehFM.png',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 16),
              // TITULO PRINCIPAL
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
                decoration: InputDecoration(
                  hintText: 'Cédula',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('lib/presentation/images/logoEcolapp.png'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenido a EcolApp',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Hola, ingresa tus datos para continuar'),
                ],
              ),
              const SizedBox(height: 12),
              // CAMPO DE CONTRASEÑA
              Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
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
                  child: const Text('Olvidaste Tu Contraseña?'),
                ),
              ),
              const SizedBox(height: 16),
              // BOTÓN DE INICIO DE SESIÓN
              Obx(() => ElevatedButton(
                    onPressed: controller.authController.isLoading.value
                        ? null
                        : controller.signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
            ),
            const SizedBox(height: 12),
            Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    child: controller.authController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Iniciar Sesión',
                            style: TextStyle(color: Colors.white)),
                  )),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('ó'),
                  ),
                  Expanded(child: Divider()),
                ],
                )),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed('/forgot-password'),
                child: const Text('¿Olvidaste la contraseña?'),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: controller.authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Ingresa',
                          style: TextStyle(color: Colors.white)),
                )),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('o'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: const Icon(Icons.fingerprint),
                label: const Text('Iniciar Sesión con Touch ID'),
              ),
              const SizedBox(height: 30),
              // LINK DE REGISTRO
              TextButton(
                onPressed: () => Get.toNamed('/sign-up'),
                child: const Text("No Tienes Cuenta? Registrate!"),
              icon: const Icon(Icons.fingerprint),
              label: const Text('Ingresa con autenticación biométrica'),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed('/sign-up'),
                child: const Text("¿No tienes cuenta? Registrate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
