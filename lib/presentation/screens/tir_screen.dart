import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tir_controller.dart';

class TirPage extends StatelessWidget {
  final TirController controller = Get.put(TirController());
  final TextEditingController flujoController = TextEditingController();
  final RxList<double> flujos = <double>[].obs;

  TirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Tasa Interna de Retorno (TIR)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(flujoController, 'Agregar flujo de caja'),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _agregarFlujo,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
                const SizedBox(width: 10),
                Obx(() => Text(
                      'Total flujos: ${flujos.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Flujos ingresados:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => Wrap(
                  spacing: 8,
                  children: flujos
                      .asMap()
                      .entries
                      .map((entry) => Chip(
                            label: Text('${entry.value.toStringAsFixed(2)}'),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () => flujos.removeAt(entry.key),
                          ))
                      .toList(),
                )),
            const SizedBox(height: 20),
            _buildCalcularButton(),
            const SizedBox(height: 20),
            Obx(() => Text(
                  'TIR: ${controller.tir.value * 100} %',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            Obx(() => Text(
                  'Iteraciones usadas: ${controller.iterationsUsed.value}',
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }

  void _agregarFlujo() {
    final texto = flujoController.text;
    if (texto.isEmpty) return;

    final valor = double.tryParse(texto.replaceAll(',', '.'));
    if (valor == null) {
      Get.snackbar('Error', 'Ingresa un número válido');
    } else {
      flujos.add(valor);
      flujoController.clear();
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => controller.clear(),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildCalcularButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          try {
            controller.calcularTIR(flujos: flujos.toList());
          } catch (e) {
            Get.snackbar('Error en cálculo', e.toString(),
                backgroundColor: Colors.red.shade100);
          }
        },
        icon: const Icon(Icons.calculate),
        label: const Text('Calcular TIR'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
