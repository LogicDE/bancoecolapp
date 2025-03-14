import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/annuity_controller.dart';

class AnnuitiesPage extends StatefulWidget {
  @override
  _AnnuitiesPageState createState() => _AnnuitiesPageState();
}

class _AnnuitiesPageState extends State<AnnuitiesPage> {
  final AnnuityController controller = Get.put(AnnuityController());
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController periodsController = TextEditingController();
  final TextEditingController futureValueController = TextEditingController();
  String selectedCapitalization = 'Anual';
  String selectedPaymentFrequency = 'Mensual';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cálculo de Anualidades")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputFields(),
            const SizedBox(height: 10),
            _buildDropdowns(),
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

  /// 🟢 **Campos de entrada organizados en un `Card`**
  Widget _buildInputFields() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(amountController, "Pago (A)"),
            _buildTextField(rateController, "Tasa de interés anual (%)"),
            _buildTextField(periodsController, "Duración (años)"),
            _buildTextField(futureValueController, "Valor Futuro (VF)"),
          ],
        ),
      ),
    );
  }

  /// 🟢 **Campo de texto con diseño reutilizable**
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

  /// 🟢 **Dropdowns organizados**
  Widget _buildDropdowns() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Frecuencia de Capitalización"),
        DropdownButton<String>(
          value: selectedCapitalization,
          onChanged: (newValue) =>
              setState(() => selectedCapitalization = newValue!),
          items: _buildDropdownItems(),
        ),
        const SizedBox(height: 10),
        Text("Frecuencia de Pago"),
        DropdownButton<String>(
          value: selectedPaymentFrequency,
          onChanged: (newValue) =>
              setState(() => selectedPaymentFrequency = newValue!),
          items: _buildDropdownItems(),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return ['Anual', 'Semestral', 'Trimestral', 'Cuatrimestral', 'Mensual']
        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
        .toList();
  }

  /// 🟢 **Botones bien organizados con `Wrap` para evitar overflow**
  Widget _buildActionButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _buildButton("Calcular Anualidad", Icons.calculate, () {
          double A = double.tryParse(amountController.text) ?? 0;
          double annualRate = double.tryParse(rateController.text) ?? 0;
          int years = int.tryParse(periodsController.text) ?? 0;
          if (A > 0 && annualRate >= 0 && years > 0) {
            controller.calculateAnnuity(A, annualRate, years,
                selectedCapitalization, selectedPaymentFrequency);
          } else {
            Get.snackbar("Error", "Ingrese valores válidos");
          }
        }),
        _buildButton("Calcular Tasa", Icons.percent, () {
          double A = double.tryParse(amountController.text) ?? 0;
          double VF = double.tryParse(futureValueController.text) ?? 0;
          int years = int.tryParse(periodsController.text) ?? 0;
          if (A > 0 && VF > 0 && years > 0) {
            controller.calculateAnnuityRate(A, VF, years);
          } else {
            Get.snackbar("Error", "Ingrese valores válidos para la tasa");
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

  /// 🟢 **Resultados dentro de un `Card` para mejor visualización**
  Widget _buildResults() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => _buildResultText(
                "Valor Futuro: \$${controller.futureValue.value.toStringAsFixed(2)}")),
            Obx(() => _buildResultText(
                "Valor Presente: \$${controller.presentValue.value.toStringAsFixed(2)}")),
            Obx(() => _buildResultText(
                "Tasa de Interés: ${controller.rate.value.toStringAsFixed(6)}%")),
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

  /// 🟢 **Gráfica con `Expanded` para mejor distribución del espacio**
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
                spots: controller.annuityProgression
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                    .toList(),
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
