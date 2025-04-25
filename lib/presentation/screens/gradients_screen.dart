import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/gradients_controller.dart';

class GradientsPage extends StatefulWidget {
  @override
  State<GradientsPage> createState() => _GradientsPageState();
}

class _GradientsPageState extends State<GradientsPage> {
  final controller = Get.put(GradientsController());

  final firstPaymentController = TextEditingController();
  final increaseController = TextEditingController();
  final periodsController = TextEditingController();
  final rateController = TextEditingController();

  String selectedGradient = 'Aritmético';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cálculo de Gradientes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGradientSelector(),
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

  Widget _buildGradientSelector() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Selecciona el tipo de Gradiente:"),
            DropdownButton<String>(
              value: selectedGradient,
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedGradient = value;
                  });
                }
              },
              items: [
                'Aritmético',
                'Geométrico Creciente',
                'Geométrico Decreciente',
              ]
                  .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
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
        padding: const EdgeInsets.all(16),
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

  Widget _buildTextField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 10,
      children: [
        _buildButton(
            "Calcular Valor Presente", Icons.calculate, _calcularValorPresente),
        _buildButton(
            "Calcular Valor Futuro", Icons.timeline, _calcularValorFuturo),
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

  void _calcularValorPresente() {
    final datos = _obtenerDatos();
    if (datos == null) return;

    final (P, G, n, iRaw) = datos;
    final i = iRaw / 100;

    switch (selectedGradient) {
      case 'Aritmético':
        controller.calcularGradienteAritmetico(g: G, A: P, n: n, i: i);
        break;
      case 'Geométrico Creciente':
        final g = G / 100;
        controller.calcularGradienteGeometricoCreciente(g: g, A: P, n: n, i: i);
        break;
      case 'Geométrico Decreciente':
        final g = G / 100;
        controller.calcularGradienteGeometricoDecreciente(
            g: g, A: P, n: n, i: i);
        break;
      default:
        Get.snackbar("Error", "Tipo de gradiente no válido.");
    }
  }

  void _calcularValorFuturo() {
    // Misma lógica de presente, reutilizable si se separa lógica en el controlador.
    _calcularValorPresente();
  }

  /// Valida e intenta obtener los datos ingresados por el usuario
  /// Devuelve una tupla (P, G, n, i) o `null` si hay error
  (double, double, int, double)? _obtenerDatos() {
    final P = double.tryParse(firstPaymentController.text.trim()) ?? -1;
    final G = double.tryParse(increaseController.text.trim()) ?? -1;
    final n = int.tryParse(periodsController.text.trim()) ?? -1;
    final i = double.tryParse(rateController.text.trim()) ?? -1;

    if (P < 0 || G < 0 || n <= 0 || i < 0) {
      Get.snackbar(
          "Error", "Por favor, ingresa todos los valores correctamente.");
      return null;
    }

    return (P, G, n, i);
  }

  Widget _buildResults() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildChart() {
    return SizedBox(
      height: 250,
      child: Obx(() {
        final data = controller.progression;
        if (data.isEmpty)
          return const Center(child: Text("Sin datos para mostrar."));

        return LineChart(
          LineChartData(
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: data
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: Colors.green,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        );
      }),
    );
  }
}
