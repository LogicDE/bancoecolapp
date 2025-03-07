import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/simple_interest_controller.dart';

class SimpleInterestScreen extends StatelessWidget {
  const SimpleInterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimpleInterestController(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Interés Simple')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SimpleInterestController>(
            builder: (context, controller, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.futureValueController,
                    decoration:
                        const InputDecoration(labelText: 'Monto Futuro (F)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: controller.capitalController,
                    decoration:
                        const InputDecoration(labelText: 'Capital Inicial (P)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: controller.rateController,
                    decoration: const InputDecoration(
                        labelText: 'Tasa de Interés (%) (i)'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: controller.timeController,
                    decoration:
                        const InputDecoration(labelText: 'Tiempo (años) (n)'),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 10),

                  // Selector de periodo de la tasa de interés
                  const Text('Periodo de la tasa de interés:'),
                  DropdownButton<String>(
                    value: controller.selectedPeriod,
                    items: controller.periodFactors.keys.map((String period) {
                      return DropdownMenuItem<String>(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.setPeriod(newValue);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: controller.calculate,
                      child: const Text('Calcular'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      controller.result,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
