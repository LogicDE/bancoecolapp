import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/loan_controller.dart';

class LoanReportPage extends StatelessWidget {
  final LoanController controller = Get.put(LoanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Préstamo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Monto: \$${controller.monto.value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Tasa de Interés: ${controller.tasa.value.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Plazo: ${controller.tiempo.value} años',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Tipo de Interés: ${controller.tipoInteres.value == TipoInteres.simple ? 'Interés Simple' : 'Interés Compuesto'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  'Cuota Mensual: \$${controller.cuotaMensual.value.toStringAsFixed(2)}\n'
                  'Total a Pagar: \$${controller.totalAPagar.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await controller
                    .solicitarPrestamo(); // Llama al método del controlador
              },
              child: const Text('Solicitar Préstamo'),
            ),
          ],
        ),
      ),
    );
  }
}
