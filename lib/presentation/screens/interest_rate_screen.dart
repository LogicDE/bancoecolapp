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
          onPressed: () {
            Get.back(); // Regresa al DashboardPage
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => Text(
                  'Modo: ${controller.selectedType.value}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            TextField(
              controller: controller.presentValueController,
              decoration:
                  const InputDecoration(labelText: 'Valor Presente (VP o C)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: controller.futureValueController,
              decoration:
                  const InputDecoration(labelText: 'Valor Futuro (VF o MC)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: controller.timeController,
              decoration: const InputDecoration(labelText: 'Tiempo (t o n)'),
              keyboardType: TextInputType.number,
            ),
            Obx(() => TextField(
                  controller: controller.interestController,
                  decoration:
                      const InputDecoration(labelText: 'Interés generado (I)'),
                  keyboardType: TextInputType.number,
                  enabled: controller.selectedType.value == 'Simple',
                )),
            const SizedBox(height: 10),
            Obx(() => DropdownButton<String>(
                  value: controller.selectedTimeUnit.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.setTimeUnit(newValue);
                    }
                  },
                  items: <String>['Años', 'Meses', 'Días']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.setType('Simple');
                  },
                  child: const Text('Interés Simple'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.setType('Compuesto');
                  },
                  child: const Text('Interés Compuesto'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.calculate(),
              child: const Text('Calcular'),
            ),
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
}
