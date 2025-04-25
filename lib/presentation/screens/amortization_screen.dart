import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/amortization_controller.dart';
import '../widgets/mode_button.dart';

class AmortizationScreen extends StatelessWidget {
  final controller = Get.put(AmortizationController());

  AmortizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Amortización")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputField("Capital", controller.capitalCtrl),
            _buildInputField("Tasa de interés (%)", controller.rateCtrl),
            _buildInputField("Períodos", controller.periodsCtrl),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ModeButton(text: 'Alemana', type: 'alemana', onPressed: controller.setType),
                const SizedBox(width: 8),
                ModeButton(text: 'Francesa', type: 'francesa', onPressed: controller.setType),
                const SizedBox(width: 8),
                ModeButton(text: 'Americana', type: 'americana', onPressed: controller.setType),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.calculate,
              child: const Text("Calcular tabla"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => controller.table.isEmpty
                  ? const Center(child: Text("No hay datos para mostrar"))
                  : ListView.builder(
                      itemCount: controller.table.length,
                      itemBuilder: (context, index) {
                        final row = controller.table[index];
                        return Card(
                          child: ListTile(
                            title: Text("Periodo ${row.period}"),
                            subtitle: Text(
                                "Pago: ${row.payment.toStringAsFixed(2)} | Interés: ${row.interest.toStringAsFixed(2)}\nAmortización: ${row.amortization.toStringAsFixed(2)} | Saldo: ${row.balance.toStringAsFixed(2)}"),
                          ),
                        );
                      },
                    )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
