import 'package:bancosbase/presentation/widgets/image_wrap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/compound_interest_controller.dart';

class CompoundInterestScreen extends StatelessWidget {
  final CompoundInterestController controller =
      Get.put(CompoundInterestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Interés Compuesto")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard([
              _buildTextField(
                  controller.capitalController, "Capital Inicial (C)"),
              _buildTextField(
                  controller.interestRateController, "Tasa de Interés (%)"),
              _buildTextField(
                  controller.finalAmountController, "Monto Compuesto (MC)"),
            ]),
            Center(
              child: ImageWrap(
                imagePaths: [
                  'lib/presentation/images/ICCapital.png',
                  'lib/presentation/images/ICInteres.png',
                  'lib/presentation/images/ICMontoCompuesto.png'
                ]
              ),
            ),

            _buildTextField(
                controller.capitalController, "Capital Inicial (C)"),
            _buildTextField(
                controller.interestRateController, "Tasa de Interés (%)"),
            _buildTextField(
                controller.finalAmountController, "Monto Compuesto (MC)"),

            // Campos para el tiempo en años, meses y días
            Row(
              children: [
                Expanded(
                    child: _buildTextField(controller.yearsController, "Años")),
                SizedBox(width: 10),
                Expanded(
                    child:
                        _buildTextField(controller.monthsController, "Meses")),
                SizedBox(width: 10),
                Expanded(
                    child: _buildTextField(controller.daysController, "Días")),
              ],
            ),
            SizedBox(height: 20),
            _buildCard([
              Row(
                children: [
                  Expanded(
                      child:
                          _buildTextField(controller.yearsController, "Años")),
                  SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(
                          controller.monthsController, "Meses")),
                  SizedBox(width: 10),
                  Expanded(
                      child:
                          _buildTextField(controller.daysController, "Días")),
                ],
              ),
            ]),
            SizedBox(height: 20),
            _buildCard([
              Obx(() => DropdownButtonFormField<int>(
                    value: controller.compoundingFrequency.value,
                    items: controller.compoundingOptions.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        controller.compoundingFrequency.value = value!,
                    decoration: InputDecoration(
                        labelText: "Frecuencia de Capitalización"),
                  )),
            ]),
            SizedBox(height: 20),
            _buildCard([
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedInterestType.value,
                    items: controller.interestTypeOptions.keys.map((key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        controller.selectedInterestType.value = value!,
                    decoration:
                        InputDecoration(labelText: "Tipo de Tasa de Interés"),
                  )),
            ]),
            SizedBox(height: 20),
            Wrap(
              spacing: 10, // Espaciado horizontal entre botones
              runSpacing: 10, // Espaciado vertical si se apilan
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.calcularMontoCompuesto,
                  icon: Icon(Icons.calculate),
                  label: Text("Calcular"),
                ),
                ElevatedButton.icon(
                  onPressed: controller.calcularCapital,
                  icon: Icon(Icons.attach_money),
                  label: Text("Capital"),
                ),
                ElevatedButton.icon(
                  onPressed: controller.calcularTasaInteres,
                  icon: Icon(Icons.percent),
                  label: Text("Tasa"),
                ),
                ElevatedButton.icon(
                  onPressed: controller.calcularTiempo,
                  icon: Icon(Icons.timer),
                  label: Text("Tiempo"),
            // Botón de Cálculo
            Center(
              child:
                ElevatedButton(
                onPressed: controller.calcularMontoCompuesto,
                child: Text("Calcular Monto Compuesto")),
            // Botones de Cálculos Inversos
            ),
            SizedBox(height: 10),
          Wrap(
              alignment: WrapAlignment.center, // Centra los botones
              spacing: 10, // Espaciado entre los botones
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: controller.calcularCapital,
                  child: Text("Calcular Capital"),
                ),
                ElevatedButton(
                  onPressed: controller.calcularTasaInteres,
                  child: Text("Calcular Tasa"),
                ),
                ElevatedButton(
                  onPressed: controller.calcularTiempo,
                  child: Text("Calcular Tiempo"),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildCard([
              Obx(() => Text(
                  "Monto Futuro: \$${controller.montoCompuesto.value.toStringAsFixed(2)}")),
              Obx(() => Text(
                  "Interés Compuesto: \$${controller.intereses.value.toStringAsFixed(2)}")),
              Obx(() => Text(
                  "Capital Inicial: \$${controller.capital.value.toStringAsFixed(2)}")),
              Obx(() => Text(
                  "Tasa de Interés: ${controller.tasaInteres.value.toStringAsFixed(2)}%")),
              Obx(() {
                int anios = controller.tiempoEnMeses.value ~/ 12;
                int meses = controller.tiempoEnMeses.value % 12;
                return Text("Tiempo: $anios años y $meses meses");
              }),
            ]),
            SizedBox(height: 20),
            _buildCard([
              SizedBox(
                height: 300,
                child: Obx(() {
                  if (controller.chartData.isEmpty) {
                    return Center(child: Text("No hay datos aún"));
                  }
                  return SfCartesianChart(
                    primaryXAxis:
                        NumericAxis(title: AxisTitle(text: "Tiempo (meses)")),
                    primaryYAxis:
                        NumericAxis(title: AxisTitle(text: "Monto (\$)")),
                    series: <LineSeries<double, double>>[
                      LineSeries<double, double>(
                        dataSource: controller.chartData,
                        xValueMapper: (double value, int index) =>
                            index.toDouble(),
                        yValueMapper: (double amount, _) => amount,
                        name: "Crecimiento",
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  );
                }),
              ),
            ]),

            // Resultados
            Obx(() => Text(
                "Monto Futuro: \$${controller.montoCompuesto.value.toStringAsFixed(2)}")),
            Obx(() => Text(
                "Interés Compuesto: \$${controller.intereses.value.toStringAsFixed(2)}")),
            Obx(() => Text(
                "Capital Inicial: \$${controller.capital.value.toStringAsFixed(2)}")),
            Obx(() => Text(
                "Tasa de Interés: ${controller.tasaInteres.value.toStringAsFixed(2)}%")),
            Obx(() {
              int anios =
                  controller.tiempoEnMeses.value ~/ 12; // Obtener los años
              int meses = controller.tiempoEnMeses.value %
                  12; // Obtener los meses restantes
              return Text("Tiempo: $anios años y $meses meses");
            }),

            SizedBox(height: 20),

            // Gráfico de Crecimiento
            Obx (() => SizedBox(
              height:controller.chartData.isEmpty ? 20 : 300,
              child: Obx(() {
                if (controller.chartData.isEmpty) {
                  return Center(child: Text("No hay datos aún"));
                }
                return SfCartesianChart(
                  primaryXAxis:
                      NumericAxis(title: AxisTitle(text: "Tiempo (meses)")),
                  primaryYAxis:
                      NumericAxis(title: AxisTitle(text: "Monto (\$)")),
                  series: <LineSeries<double, double>>[
                    LineSeries<double, double>(
                      dataSource: controller.chartData,
                      xValueMapper: (double value, int index) =>
                          index.toDouble(),
                      yValueMapper: (double amount, _) => amount,
                      name: "Crecimiento",
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                );
              }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }
}
