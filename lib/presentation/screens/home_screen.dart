import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
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
  ];

  void _logout() async {
    await FirebaseAuth.instance.signOut(); // Cierra sesión en Firebase
    Get.offAllNamed("/sign-in"); // Redirige a la pantalla de inicio de sesión
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 20, backgroundColor: Colors.grey.shade300),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Hola, Usuario",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const Text("Bienvenido de nuevo!",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      /*IconButton(
                        icon: const Icon(Iconsax.notification, size: 28),
                        onPressed: () {},
                      ),*/
                      IconButton(
                        icon: const Icon(Iconsax.logout,
                            size: 28, color: Colors.red),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              /*Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Balance",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text("\$3,469.52",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("**** **** **** 1076",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),*/
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ElevatedButton(
                      onPressed: () => Get.toNamed(option["route"]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(16),
                        elevation: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(option["icon"],
                              size: 40, color: Colors.blueAccent),
                          const SizedBox(height: 10),
                          Text(option["label"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
