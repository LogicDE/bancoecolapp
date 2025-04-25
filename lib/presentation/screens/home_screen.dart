import 'package:bancosbase/presentation/controllers/loan_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> options = [
    {
      "icon": Iconsax.activity,
      "label": "Tasa Interés",
      "route": "/interest-rate"
    },
    {
      "icon": Iconsax.trend_up,
      "label": "Interés Simple",
      "route": "/simple-interest"
    },
    {
      "icon": Iconsax.graph,
      "label": "Interés Compuesto",
      "route": "/compound-interest"
    },
    {"icon": Iconsax.wallet, "label": "Anualidades", "route": "/annuities"},
    {"icon": Iconsax.status_up, "label": "Gradientes", "route": "/gradients"},
    {"icon": Iconsax.money, "label": "Amortización", "route": "/amortization"},
    {"icon": Iconsax.user, "label": "TIR", "route": "/tir"},
    {"icon": Iconsax.settings, "label": "Configuración", "route": "/settings"},
    {"icon": Iconsax.wallet_2, "label": "Mis Préstamos", "route": "/loan-menu"},
    {"icon": Iconsax.archive1, "label": "Capitalización", "route": "/capitalization"},
    {"icon": Iconsax.user, "label": "Perfil", "route": "/profile"},
    {"icon": Iconsax.settings, "label": "Configuración", "route": "/settings"},
  ];

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed("/sign-in");
  }

  @override
  void initState() {
    super.initState();
    final LoanController controller = Get.put(LoanController());
    controller.obtenerSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildBalanceCard(),
              const SizedBox(height: 20),
              Expanded(child: _buildOptionsGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueAccent.shade100,
              child: const Icon(Iconsax.user, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hola, Usuario",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text("Bienvenido de nuevo!",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Iconsax.notification,
                  size: 28, color: Colors.black54),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Iconsax.logout, size: 28, color: Colors.red),
              onPressed: _logout,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionsGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return GestureDetector(
          onTap: () => Get.toNamed(option["route"]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(option["icon"], size: 40, color: Colors.blueAccent),
                const SizedBox(height: 10),
                Text(option["label"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard() {
    final LoanController controller = Get.put(LoanController());

    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blue.shade700],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Saldo disponible",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Text("\$${controller.saldoDisponible.value.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 8),
              const Text("EcolApp", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ));
  }
}
