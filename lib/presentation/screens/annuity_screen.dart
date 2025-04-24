import 'package:bancosbase/presentation/widgets/image_wrap.dart';
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

  final amountController = TextEditingController();
  final rateController = TextEditingController();
  final periodsController = TextEditingController();
  final futureValueController = TextEditingController();

  String selectedCapitalization = 'Anual';
  String selectedPaymentFrequency = 'Mensual';

  final List<String> options = [
    'Anual',
    'Semestral',
    'Trimestral',
    'Cuatrimestral',
    'Mensual'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cálculo de Anualidades")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImageSection(),
            _buildInputFields(),
            _buildDropdowns(),
            _buildActionButtons(),
            _buildResults(),
            _buildChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: ImageWrap(imagePaths: [
        'lib/presentation/images/AValorActual.png',
        'lib/presentation/images/AValorFinal.png',
      ]),
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
            _buildTextField(amountController, "Pago (A)"),
            _buildTextField(rateController, "Tasa de interés anual (%)"),
            _buildTextField(periodsController, "Duración (años)"),
            _buildTextField(futureValueController, "Valor Futuro (VF)"),
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
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDropdowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown("Frecuencia de Capitalización", selectedCapitalization,
              (val) => setState(() => selectedCapitalization = val)),
          SizedBox(height: 10),
          _buildDropdown("Frecuencia de Pago", selectedPaymentFrequency,
              (val) => setState(() => selectedPaymentFrequency = val)),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String label, String currentValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: currentValue,
          onChanged: (newValue) => onChanged(newValue!),
          items: options
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _buildButton(
            "Calcular Anualidad", Icons.calculate, _onCalculateAnnuity),
        _buildButton("Calcular Tasa", Icons.percent, _onCalculateRate),
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

  void _onCalculateAnnuity() {
    double A = double.tryParse(amountController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    int years = int.tryParse(periodsController.text) ?? 0;
    if (A > 0 && rate >= 0 && years > 0) {
      controller.calculateAnnuity(
          A, rate, years, selectedCapitalization, selectedPaymentFrequency);
    } else {
      Get.snackbar("Error", "Ingrese valores válidos");
    }
  }

  void _onCalculateRate() {
    double A = double.tryParse(amountController.text) ?? 0;
    double VF = double.tryParse(futureValueController.text) ?? 0;
    int years = int.tryParse(periodsController.text) ?? 0;
    if (A > 0 && VF > 0 && years > 0) {
      controller.calculateAnnuityRate(A, VF, years);
    } else {
      Get.snackbar("Error", "Ingrese valores válidos para la tasa");
    }
  }

  Widget _buildResults() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildChart() {
    return SizedBox(
      height: 250,
      child: Obx(() => LineChart(
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
          )),
    );
  }
}
