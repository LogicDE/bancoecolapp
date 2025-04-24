import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/gradients_controller.dart';

class GradientsPage extends StatefulWidget {
  @override
  _GradientsPageState createState() => _GradientsPageState();
}

class _GradientsPageState extends State<GradientsPage> {
  final GradientsController controller = Get.put(GradientsController());
  final TextEditingController firstPaymentController = TextEditingController();
  final TextEditingController increaseController = TextEditingController();
  final TextEditingController periodsController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  // Variable para seleccionar el tipo de gradiente
  String selectedGradient = 'Aritmético';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cálculo de Gradientes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientSelector(), // Selector de tipo de gradiente
            const SizedBox(height: 20),
            _buildInputFields(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            _buildResults(),
            const SizedBox(height: 20),
            _buildChart(),
          ],
        ),
      ),
    );
  }

  // Selector para elegir el tipo de gradiente
  Widget _buildGradientSelector() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Selecciona el tipo de Gradiente:"),
            DropdownButton<String>(
              value: selectedGradient,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGradient = newValue!;
                });
              },
              items: <String>[
                'Aritmético',
                'Geométrico Creciente',
                'Geométrico Decreciente'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(firstPaymentController, "Primer Pago (P)"),
            _buildTextField(increaseController, "Incremento por período (G)"),
            _buildTextField(periodsController, "Número de períodos (n)"),
            _buildTextField(rateController, "Tasa de interés (%)"),
          ],
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

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 10,
      children: [
        _buildButton("Calcular Valor Presente", Icons.calculate, () {
          double P = double.tryParse(firstPaymentController.text) ?? 0;
          double G = double.tryParse(increaseController.text) ?? 0;
          int n = int.tryParse(periodsController.text) ?? 0;
          double i = double.tryParse(rateController.text) ?? 0;

          if (P >= 0 && G >= 0 && n > 0 && i >= 0) {
            if (selectedGradient == 'Aritmético') {
              controller.calcularGradienteAritmetico(
                  g: G, A: P, n: n, i: i / 100);
            } else if (selectedGradient == 'Geométrico Creciente') {
              controller.calcularGradienteGeometricoCreciente(
                  g: G, A: P, n: n, i: i / 100);
            } else if (selectedGradient == 'Geométrico Decreciente') {
              controller.calcularGradienteGeometricoDecreciente(
                  g: G, A: P, n: n, i: i / 100);
            } else {
              Get.snackbar("Error", "Tipo de gradiente no válido.");
            }
          } else {
            Get.snackbar(
                "Error", "Por favor ingrese todos los valores correctamente.");
          }
        }),
        _buildButton("Calcular Valor Futuro", Icons.timeline, () {
          double P = double.tryParse(firstPaymentController.text) ?? 0;
          double G = double.tryParse(increaseController.text) ?? 0;
          int n = int.tryParse(periodsController.text) ?? 0;
          double i = double.tryParse(rateController.text) ?? 0;

          if (P >= 0 && G >= 0 && n > 0 && i >= 0) {
            if (selectedGradient == 'Aritmético') {
              controller.calcularGradienteAritmetico(
                  g: G, A: P, n: n, i: i / 100);
            } else if (selectedGradient == 'Geométrico Creciente') {
              controller.calcularGradienteGeometricoCreciente(
                  g: G, A: P, n: n, i: i / 100);
            } else if (selectedGradient == 'Geométrico Decreciente') {
              controller.calcularGradienteGeometricoDecreciente(
                  g: G, A: P, n: n, i: i / 100);
            } else {
              Get.snackbar("Error", "Tipo de gradiente no válido.");
            }
          } else {
            Get.snackbar(
                "Error", "Datos inválidos para calcular el valor futuro.");
          }
        }),
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }

  Widget _buildResults() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => _buildResultText(
                "Valor Presente: \$${controller.presentValue.value.toStringAsFixed(2)}")),
            Obx(() => _buildResultText(
                "Valor Futuro: \$${controller.futureValue.value.toStringAsFixed(2)}")),
          ],
        ),
      ),
    );
  }

  Widget _buildResultText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 250,
      child: Obx(
        () => LineChart(
          LineChartData(
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: controller.progression
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                    .toList(),
                isCurved: true,
                color: Colors.green,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
