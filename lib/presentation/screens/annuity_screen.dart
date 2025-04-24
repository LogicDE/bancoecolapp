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
  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController periodsController = TextEditingController();
  String selectedCapitalization = 'Anual';
  String selectedPaymentFrequency = 'Mensual';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cálculo de Anualidades")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
          children: [
            Center(
              child: ImageWrap(
                      imagePaths: [
                        'lib/presentation/images/AValorActual.png',
                        'lib/presentation/images/AValorFinal.png'
                      ]
                    ),
             ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: "Pago (A)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: rateController,
              decoration:
                  InputDecoration(labelText: "Tasa de interés anual (%)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: periodsController,
              decoration: InputDecoration(labelText: "Duración (años)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Text("Frecuencia de Capitalización"),
            DropdownButton<String>(
              value: selectedCapitalization,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCapitalization = newValue;
                  });
                }
              },
              items: [
                'Anual',
                'Semestral',
                'Trimestral',
                'Cuatrimestral',
                'Mensual'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text("Frecuencia de Pago"),
            DropdownButton<String>(
              value: selectedPaymentFrequency,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedPaymentFrequency = newValue;
                  });
                }
              },
              items: [
                'Anual',
                'Semestral',
                'Trimestral',
                'Cuatrimestral',
                'Mensual'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double A = double.tryParse(amountController.text) ?? 0;
                double annualRate = double.tryParse(rateController.text) ?? 0;
                int years = int.tryParse(periodsController.text) ?? 0;
                if (A > 0 && annualRate >= 0 && years > 0) {
                  controller.calculateAnnuity(A, annualRate, years,
                      selectedCapitalization, selectedPaymentFrequency);
                } else {
                  Get.snackbar("Error", "Ingrese valores válidos");
                }
              },
              child: Text("Calcular"),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
                "Valor Futuro: \$${controller.futureValue.value.toStringAsFixed(2)}")),
            Obx(() => Text(
                "Valor Presente: \$${controller.presentValue.value.toStringAsFixed(2)}")),
            Expanded(
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
                            .map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value);
                        }).toList(),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
          )
        )
      ),
    );
  }
}
