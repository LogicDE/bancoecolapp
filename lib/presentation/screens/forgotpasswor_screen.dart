import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String code = "";

  void handleNumberPress(String number) {
    if (code.length < 6) {
      setState(() {
        code += number;
      });
    }
  }

  void handleDelete() {
    if (code.isNotEmpty) {
      setState(() {
        code = code.substring(0, code.length - 1);
      });
    }
  }

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
                    icon: const Icon(Iconsax.arrow_left, size: 28),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  const Text("Forgot password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 20),

              // Input Field
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Type your phone number",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                controller: TextEditingController(text: code),
              ),
              const SizedBox(height: 8),
              const Text("We'll send you a code to verify your phone number",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),

              // Custom Number Pad
              Expanded(
                child: GridView.builder(
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return const SizedBox.shrink(); // Espacio vacío
                    } else if (index == 10) {
                      return _numberButton("0");
                    } else if (index == 11) {
                      return _deleteButton();
                    } else {
                      return _numberButton("${index + 1}");
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Send Button
              ElevatedButton(
                onPressed: () {
                  // Acción de envío del código
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Send",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberButton(String number) {
    return GestureDetector(
      onTap: () => handleNumberPress(number),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(number,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return GestureDetector(
      onTap: handleDelete,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Iconsax.arrow_left, size: 28, color: Colors.red),
        ),
      ),
    );
  }
}
