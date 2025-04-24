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
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        Image.asset('lib/presentation/images/ISMonto.png'),
                        Image.asset('lib/presentation/images/ISValorFinal.png'),
                        Image.asset('lib/presentation/images/ISTiempo.png'),
                        Image.asset('lib/presentation/images/ISValorPresente.png'),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    _buildTextField(
                        controller.futureValueController, 'Monto Futuro (F)'),
                    _buildTextField(
                        controller.capitalController, 'Capital Inicial (P)'),
                    _buildTextField(
                        controller.rateController, 'Tasa de Interés (%) (i)'),
                    _buildTextField(
                        controller.timeController, 'Tiempo (años) (n)'),
                    _buildTextField(
                        controller.interestController, 'Interés Generado (I)'),
                    const SizedBox(height: 10),
                    _buildDropdown(controller),
                    const SizedBox(height: 20),
                    _buildButtons(controller),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDropdown(SimpleInterestController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Periodo de la tasa de interés:'),
        DropdownButton<String>(
          value: controller.selectedPeriod,
          isExpanded: true,
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
      ],
    );
  }

  Widget _buildButtons(SimpleInterestController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: controller.calculate,
          child: const Text('Calcular'),
        ),
        ElevatedButton(
          onPressed: controller.clearFields,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text('Limpiar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
