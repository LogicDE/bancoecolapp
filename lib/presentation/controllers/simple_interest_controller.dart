import 'package:flutter/material.dart';

class SimpleInterestController extends ChangeNotifier {
  final TextEditingController capitalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController futureValueController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

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
    double? interest = double.tryParse(interestController.text);

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

    if (interest == null && capital != null && futureValue != null) {
      // Calcular el interés generado
      interest = futureValue - capital;
      result = 'El interés generado es: \$${interest.toStringAsFixed(2)}';
    } else if (capital == null &&
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
        interest != null &&
        rate != null) {
      // Calcular el tiempo necesario
      time = interest / (capital * rate);

      // Conversión a años, meses y días
      int years = time.floor();
      double fractionalYear = time - years;
      int days = (fractionalYear * 360).round();
      int months = (days / 30).floor();
      days = days % 30;

      result = 'El tiempo estimado es: $years años, $months meses, $days días';
    } else if (capital == null &&
        interest != null &&
        rate != null &&
        time != null) {
      // Calcular el capital inicial cuando solo se tienen I, i y t
      capital = interest / (rate * time);
      result = 'El capital inicial es: \$${capital.toStringAsFixed(2)}';
    } else {
      result = 'Por favor, ingresa al menos tres valores.';
    }

    notifyListeners();
  }

  void clearFields() {
    capitalController.clear();
    rateController.clear();
    timeController.clear();
    futureValueController.clear();
    interestController.clear();
    result = '';
    notifyListeners();
  }

  @override
  void dispose() {
    capitalController.dispose();
    rateController.dispose();
    timeController.dispose();
    futureValueController.dispose();
    interestController.dispose();
    super.dispose();
  }
}
