import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/sign_up_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildWelcomeSection(),
              const SizedBox(height: 32),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('lib/presentation/images/logoEcolapp.png'),
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                  controller.cedulaController, "Cédula", TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(controller.emailController, "Email",
                  TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildTextField(controller.passwordController, "Contraseña",
                  TextInputType.text,
                  obscureText: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Obx(() => Checkbox(
                        value: controller.isLoading.value,
                        onChanged: (value) {
                          controller.isLoading.value = value ?? false;
                        },
                      )),
                  const Expanded(
                    child: Text(
                      "Al crear una cuenta aceptas nuestros Términos y Condiciones",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Registrarse",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed('/sign-in'),
                  child: const Text(
                    "¿Ya tienes una cuenta? Inicia sesión",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Iconsax.arrow_left, size: 28),
          onPressed: () => Get.back(),
        ),
        const SizedBox(width: 8),
        const Text(
          "Registro",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Center(
      child: Column(
        children: const [
          Image(
            image: NetworkImage('https://i.imgur.com/pZRehFM.png'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            "Bienvenido a EcolApp",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Crea tu cuenta con tu cédula, correo y contraseña",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, TextInputType inputType,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
