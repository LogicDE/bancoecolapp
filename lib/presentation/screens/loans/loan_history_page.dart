import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/loan_controller.dart';

class LoanHistoryPage extends StatelessWidget {
  final LoanController controller = Get.put(LoanController());

  LoanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cargar historial al iniciar la vista
    controller.obtenerHistorialPrestamos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Préstamos'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Obx(() {
        final prestamos = controller.historialPrestamos;

        if (prestamos.isEmpty) {
          return const Center(
            child: Text('No tienes préstamos registrados.'),
          );
        }

        return ListView.builder(
          itemCount: prestamos.length,
          itemBuilder: (context, index) {
            final p = prestamos[index];
            final fecha =
                DateFormat('dd/MM/yyyy – hh:mm a').format(p['fechaSolicitud']);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  'Préstamo de \$${p['monto'].toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Fecha: $fecha\n'
                    'Tasa: ${p['tasa']}%  |  Plazo: ${p['tiempo']} años\n'
                    'Interés: ${p['tipoInteres']}\n'
                    'Cuota mensual: \$${p['cuotaMensual'].toStringAsFixed(2)}\n'
                    'Total a pagar: \$${p['totalAPagar'].toStringAsFixed(2)}',
                    style: const TextStyle(height: 1.4),
                  ),
                ),
                onTap: () {
                  // Aquí podrías abrir una pantalla con el detalle de las cuotas
                },
              ),
            );
          },
        );
      }),
    );
  }
}
