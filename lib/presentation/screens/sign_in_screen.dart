import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/sign_in_controller.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Iconsax.lock, size: 50, color: Colors.blue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Hello there, sign in to continue'),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller:
                  controller.emailController, // Conectado con el controlador
              decoration: InputDecoration(
                hintText: 'Email or Username',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Obx(() => TextField(
                  controller: controller
                      .passwordController, // Conectado con el controlador
                  obscureText:
                      !controller.isPasswordVisible.value, // Usa el observable
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                child: Text('Forgot your password?'),
              ),
            ),
            SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed: controller.authController.isLoading.value
                      ? null
                      : controller.signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign in', style: TextStyle(color: Colors.white)),
                )),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.fingerprint),
              label: Text('Sign in with Touch ID'),
            ),
            Spacer(),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed('/sign-up'),
                child: Text("Don't have an account? Sign up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
