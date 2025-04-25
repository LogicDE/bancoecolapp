import 'package:flutter/material.dart';
import '../controllers/capitalization_controller.dart';

class CapitalizationScreen extends StatefulWidget {
  const CapitalizationScreen({Key? key}) : super(key: key);

  @override
  State<CapitalizationScreen> createState() => _CapitalizationScreenState();
}

class _CapitalizationScreenState extends State<CapitalizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = CapitalizationController();

  double capital = 10000;
  double rate = 5;
  int time = 5;
  int frequency = 1;

  void _calculate() {
    controller.calculate(capital, rate, time, frequency);
    setState(() {});
  }

  String _typeLabel(CapitalizationType type) {
    switch (type) {
      case CapitalizationType.simple:
        return 'Simple';
      case CapitalizationType.compound:
        return 'Compuesta';
      case CapitalizationType.continuous:
        return 'Continua';
      case CapitalizationType.periodic:
        return 'Periódica';
      case CapitalizationType.anticipada:
        return 'Anticipada';
      case CapitalizationType.diferida:
        return 'Diferida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capitalización')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Capital Inicial'),
                initialValue: capital.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => capital = double.tryParse(value) ?? capital,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tasa de Interés (%)'),
                initialValue: rate.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => rate = double.tryParse(value) ?? rate,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tiempo (años)'),
                initialValue: time.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => time = int.tryParse(value) ?? time,
              ),
              if (controller.selectedType == CapitalizationType.compound ||
                  controller.selectedType == CapitalizationType.periodic)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Frecuencia (por año)'),
                  initialValue: frequency.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => frequency = int.tryParse(value) ?? frequency,
                ),
              if (controller.selectedType == CapitalizationType.diferida)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'tiempo diferido (año)'),
                  initialValue: frequency.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => frequency = int.tryParse(value) ?? frequency,
                ),
              DropdownButtonFormField<CapitalizationType>(
                value: controller.selectedType,
                decoration: const InputDecoration(labelText: 'Tipo de Capitalización'),
                items: CapitalizationType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_typeLabel(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      controller.selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 16),
              if (controller.table.isNotEmpty)
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Periodo')),
                    DataColumn(label: Text('Interés')),
                    DataColumn(label: Text('Acumulado')),
                  ],
                  rows: controller.table
                      .map((row) => DataRow(cells: [
                            DataCell(Text(row.period.toString())),
                            DataCell(Text(row.interest.toStringAsFixed(2))),
                            DataCell(Text(row.accumulated.toStringAsFixed(2))),
                          ]))
                      .toList(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
