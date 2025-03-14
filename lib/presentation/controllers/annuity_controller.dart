import 'package:get/get.dart';
import 'dart:math';

class AnnuityController extends GetxController {
  var futureValue = 0.0.obs;
  var presentValue = 0.0.obs;
  var rate = 0.0.obs; // ✅ Nueva variable para mostrar la tasa en la UI
  List<double> annuityProgression = <double>[].obs;

  double getCapitalizationFactor(String capitalization) {
    switch (capitalization) {
      case 'Anual':
        return 1;
      case 'Semestral':
        return 2;
      case 'Trimestral':
        return 4;
      case 'Cuatrimestral':
        return 3;
      case 'Mensual':
        return 12;
      default:
        return 1;
    }
  }

  double getPaymentFrequencyFactor(String paymentFrequency) {
    switch (paymentFrequency) {
      case 'Anual':
        return 1;
      case 'Semestral':
        return 2;
      case 'Trimestral':
        return 4;
      case 'Cuatrimestral':
        return 3;
      case 'Mensual':
        return 12;
      default:
        return 1;
    }
  }

  void calculateAnnuity(double A, double annualRate, int totalPayments,
      String capitalization, String paymentFrequency) {
    double m = getCapitalizationFactor(capitalization);
    double p = getPaymentFrequencyFactor(paymentFrequency);

    // ✅ Tasa periódica correcta
    double i = (annualRate / 100) / p;

    // ✅ Número de períodos ya viene en meses, NO hay que multiplicar por 12
    int n = totalPayments;

    if (i == 0) {
      presentValue.value = A * n;
      futureValue.value = A * n;
    } else {
      presentValue.value = A * ((1 - pow(1 + i, -n)) / i);
      futureValue.value = A * ((pow(1 + i, n) - 1) / i);
    }

    annuityProgression.clear();
    double accumulated = 0;
    for (int t = 1; t <= n; t++) {
      accumulated += A;
      annuityProgression.add(accumulated * pow(1 + i, n - t));
    }
  }

  /// 🔥 **Nuevo método para calcular la tasa de interés**
  void calculateAnnuityRate(double A, double VF, int totalPayments) {
    try {
      rate.value = _newtonRaphsonRate(A, VF, totalPayments);
    } catch (e) {
      Get.snackbar("Error", "No se pudo calcular la tasa de interés");
    }
  }

  /// 🔥 **Método de Newton-Raphson para calcular la tasa**
  double _newtonRaphsonRate(double A, double VF, int n,
      {double tolerance = 1e-6, int maxIterations = 100}) {
    double i = 0.05; // Inicializar en 5% (ajustable)
    int iterations = 0;

    while (iterations < maxIterations) {
      double f_i = (pow(1 + i, n) - 1) / i - (VF / A);
      double df_i = (n * pow(1 + i, n - 1) * i - (pow(1 + i, n) - 1)) / (i * i);

      double new_i = i - f_i / df_i;

      if ((new_i - i).abs() < tolerance) return new_i * 100; // Convertir a %
      i = new_i;
      iterations++;
    }

    throw Exception("No se encontró una solución.");
  }
}
