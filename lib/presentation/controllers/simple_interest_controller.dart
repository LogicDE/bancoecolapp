import 'package:flutter/material.dart';

class SimpleInterestController extends ChangeNotifier {
  final TextEditingController capitalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController futureValueController = TextEditingController();

  String result = '';
  String selectedPeriod = 'Anual'; // Opción por defecto

  // Factores de conversión de períodos a años
  final Map<String, int> periodFactors = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12,
    'Diario': 360,
  };

  void setPeriod(String period) {
    selectedPeriod = period;
    notifyListeners();
  }

  void calculate() {
    double? capital = double.tryParse(capitalController.text);
    double? rate = double.tryParse(rateController.text);
    double? time = double.tryParse(timeController.text);
    double? futureValue = double.tryParse(futureValueController.text);

    if (rate != null) {
      rate /= 100; // Convertir porcentaje a decimal
    }

    if (time != null) {
      if (selectedPeriod == 'Diario') {
        time /= 360; // Convertir días a años correctamente
      } else {
        time *= periodFactors[selectedPeriod] ?? 1;
      }
    }

    if (capital == null &&
        futureValue != null &&
        rate != null &&
        time != null) {
      // Calcular el capital inicial
      capital = futureValue / (1 + (rate * time));
      double interestEarned = futureValue - capital;
      result =
          'El capital inicial necesario es: \$${capital.toStringAsFixed(2)}\n'
          'Intereses ganados: \$${interestEarned.toStringAsFixed(2)}';
    } else if (futureValue == null &&
        capital != null &&
        rate != null &&
        time != null) {
      // Calcular el monto futuro
      futureValue = capital * (1 + (rate * time));
      double interestEarned = futureValue - capital;
      result = 'El monto futuro será: \$${futureValue.toStringAsFixed(2)}\n'
          'Intereses ganados: \$${interestEarned.toStringAsFixed(2)}';
    } else if (rate == null &&
        capital != null &&
        futureValue != null &&
        time != null) {
      // Calcular la tasa de interés
      rate = ((futureValue / capital) - 1) / time;
      result = 'La tasa de interés es: ${(rate * 100).toStringAsFixed(2)}%';
    } else if (time == null &&
        capital != null &&
        futureValue != null &&
        rate != null) {
      // Calcular el número de períodos
      time = ((futureValue / capital) - 1) / rate;
      result = 'El número de períodos es: ${time.toStringAsFixed(2)}';
    } else {
      result = 'Por favor, ingresa al menos tres valores.';
    }

    notifyListeners();
  }

  @override
  void dispose() {
    capitalController.dispose();
    rateController.dispose();
    timeController.dispose();
    futureValueController.dispose();
    super.dispose();
  }
}
