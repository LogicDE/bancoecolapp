import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interest_rate_controller.dart';

class InterestRateScreen extends StatelessWidget {
  final InterestRateController controller = Get.put(InterestRateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Tasa de Interés'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Modo: ${controller.selectedType.value}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            _buildTextField(
                controller.presentValueController, 'Valor Presente (VP o C)'),
            _buildTextField(
                controller.futureValueController, 'Valor Futuro (VF o MC)'),
            _buildTextField(controller.timeController, 'Tiempo (t o n)'),
            Obx(() => _buildTextField(
                  controller.interestController,
                  'Interés generado (I)',
                  enabled: controller.selectedType.value == 'Simple',
                )),
            const SizedBox(height: 10),
            _buildDropdown(),
            const SizedBox(height: 20),
            _buildModeButtons(),
            const SizedBox(height: 20),
            _buildCalculateButton(),
            const SizedBox(height: 20),
            Obx(() => Text(
                  controller.result.value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        enabled: enabled,
      ),
    );
  }

  Widget _buildDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedTimeUnit.value,
          onChanged: (String? newValue) {
            if (newValue != null) controller.setTimeUnit(newValue);
          },
          items: ['Años', 'Meses', 'Días']
              .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          decoration: const InputDecoration(
            labelText: 'Unidad de Tiempo',
            border: OutlineInputBorder(),
          ),
        ));
  }

  Widget _buildModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildModeButton('Interés Simple', 'Simple'),
        const SizedBox(width: 10),
        _buildModeButton('Interés Compuesto', 'Compuesto'),
      ],
    );
  }

  Widget _buildModeButton(String text, String type) {
    return ElevatedButton(
      onPressed: () => controller.setType(type),
      child: Text(text),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
    );
  }

  Widget _buildCalculateButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => controller.calculate(),
        icon: const Icon(Icons.calculate),
        label: const Text('Calcular'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
