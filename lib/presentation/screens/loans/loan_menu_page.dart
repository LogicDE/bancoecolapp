import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoanMenuPage extends StatelessWidget {
  const LoanMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Préstamos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOption(
            icon: Iconsax.add_circle,
            label: 'Solicitar Préstamo',
            onTap: () => Get.toNamed('/loan-application'),
          ),
          const SizedBox(height: 16),
          _buildOption(
            icon: Iconsax.document,
            label: 'Historial de Préstamos',
            onTap: () => Get.toNamed('/loan-history'),
          ),
          const SizedBox(height: 16),
          _buildOption(
            icon: Iconsax.wallet_check,
            label: 'Pagos Pendientes',
            onTap: () => Get.toNamed('/loan-summary'),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
