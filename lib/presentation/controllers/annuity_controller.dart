import 'package:get/get.dart';
import 'dart:math';

class AnnuityController extends GetxController {
  var futureValue = 0.0.obs;
  var presentValue = 0.0.obs;
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
}
