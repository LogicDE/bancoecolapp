import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/loan_controller.dart';

class LoanApplicationPage extends StatelessWidget {
  final LoanController controller = Get.put(LoanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Préstamo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Monto del Préstamo'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.monto.value = double.tryParse(value) ?? 0.0;
              },
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Tasa de Interés (%)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.tasa.value = double.tryParse(value) ?? 0.0;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Plazo en Años'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.tiempo.value = int.tryParse(value) ?? 0;
              },
            ),
            Obx(() => DropdownButton<TipoInteres>(
                  value: controller.tipoInteres.value,
                  items: [
                    DropdownMenuItem(
                      value: TipoInteres.simple,
                      child: Text('Interés Simple'),
                    ),
                    DropdownMenuItem(
                      value: TipoInteres.compuesto,
                      child: Text('Interés Compuesto'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.tipoInteres.value = value;
                  },
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.calcularPrestamo();
                Get.toNamed('/loan-report');
              },
              child: const Text('Calcular Préstamo'),
            ),
            Obx(() => Text(
                  'Cuota Mensual: \$${controller.cuotaMensual.value.toStringAsFixed(2)}\n'
                  'Total a Pagar: \$${controller.totalAPagar.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }
}
