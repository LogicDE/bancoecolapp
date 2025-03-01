import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                  Text("Sign up",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 20),

              // Title
              Center(
                child: Column(
                  children: [
                    Text("Welcome to us,",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Hello there, create new account",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // User icon
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child:
                              Icon(Iconsax.user, size: 48, color: Colors.blue)),
                    ),
                    Positioned(
                        left: -5,
                        top: 0,
                        child: _buildSmallCircle(Colors.amber)),
                    Positioned(
                        right: -4,
                        bottom: 20,
                        child: _buildSmallCircle(Colors.red)),
                    Positioned(
                        left: 12,
                        bottom: -2,
                        child: _buildSmallCircle(Colors.blue)),
                    Positioned(
                        right: 12,
                        top: 12,
                        child: _buildSmallCircle(Colors.green)),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Form fields
              TextFormField(
                decoration: _inputDecoration("Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: _inputDecoration("Phone number"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: _inputDecoration("Password"),
                obscureText: true,
              ),
              SizedBox(height: 12),

              // Terms and conditions
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Expanded(
                    child: Text(
                        "By creating an account you agree to our Terms and Conditions",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Sign up button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Sign up",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(height: 16),

              // Sign in link
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navegación a Sign In
                  },
                  child: Text(
                    "Have an account? Sign in",
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
    );
  }

  Widget _buildSmallCircle(Color color) {
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
