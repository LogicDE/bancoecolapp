import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/sign_up_controller.dart';
import '../widgets/customTextField.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Iconsax.arrow_left, size: 28),
                      onPressed: () => Get.back(),
                    ),
                    SizedBox(width: 8),
                    Text("Registro",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 20),

                // Title
                Center(
                  child: Column(
                    children: [
                      Text("Bienvenido a EcolApp",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Crea tu cuenta con tu cédula, correo y contraseña",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // User icon
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/presentation/images/logoEcolapp.png'),
                  )
                ),
                SizedBox(height: 32),

                // Form fields
                TextFormField(
                  controller: controller.cedulaController,
                  decoration: _inputDecoration("Cédula"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: controller.emailController,
                  decoration: _inputDecoration("Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: _inputDecoration("Contraseña"),
                  obscureText: true,
                ),
                SizedBox(height: 12),

                // Terms and conditions
                Row(
                  children: [
                    Obx(() => Checkbox(
                          value: controller.isLoading.value,
                          onChanged: (value) {
                            controller.isLoading.value = value ?? false;
                          },
                        )),
                    Expanded(
                      child: Text(
                          "Al crear una cuenta aceptas nuestros Términos y Condiciones",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Sign up button
                Obx(() => ElevatedButton(
                      onPressed: () => controller.signUp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: controller.isLoading.value
                          ? Text("Registrarse",
                              style:
                                TextStyle(color: Colors.white, fontSize: 16)
                            )
                          : CircularProgressIndicator(color: Colors.white),
                    )),
                SizedBox(height: 16),

                // Sign in link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.offNamed('/login');
                    },
                    child: Text(
                      "¿Ya tienes una cuenta? Inicia sesión",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
