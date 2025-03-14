import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class InterestRateController extends GetxController {
  final TextEditingController futureValueController = TextEditingController();
  final TextEditingController presentValueController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  var result = ''.obs;
  var selectedType = 'Simple'.obs;
  var selectedTimeUnit = 'Años'.obs;

  void setType(String type) {
    selectedType.value = type;
    update();
  }

  void setTimeUnit(String unit) {
    selectedTimeUnit.value = unit;
    update();
  }

  void calculate() {
    if (selectedType.value == 'Simple') {
      _calculateSimpleInterest();
    } else {
      _calculateCompoundInterest();
    }
  }

  double _convertTimeToYears(double time) {
    switch (selectedTimeUnit.value) {
      case 'Meses':
        return time / 12;
      case 'Días':
        return time / 365;
      default:
        return time;
    }
  }

  void _calculateSimpleInterest() {
    double? futureValue = double.tryParse(futureValueController.text);
    double? presentValue = double.tryParse(presentValueController.text);
    double? time = double.tryParse(timeController.text);
    double? interest = double.tryParse(interestController.text);

    if (presentValue != null && futureValue != null) {
      interest = futureValue - presentValue;
      interestController.text = interest.toStringAsFixed(2);
    }

    if (interest != null && presentValue != null && time != null && time > 0) {
      double timeInYears = _convertTimeToYears(time);
      double rate = interest / (presentValue * timeInYears);
      result.value =
          'La tasa de interés es: ${(rate * 100).toStringAsFixed(2)}%';
    } else {
      result.value = 'Por favor, ingresa valores válidos.';
    }
  }

  void _calculateCompoundInterest() {
    double? futureValue = double.tryParse(futureValueController.text);
    double? presentValue = double.tryParse(presentValueController.text);
    double? time = double.tryParse(timeController.text);

    if (futureValue != null &&
        presentValue != null &&
        time != null &&
        time > 0) {
      double timeInPeriods =
          time; // No convertir a años para capitalización mensual
      double rate = pow((futureValue / presentValue), (1 / timeInPeriods)) - 1;
      result.value =
          'La tasa de interés es: ${(rate * 100).toStringAsFixed(2)}%';
    } else {
      result.value = 'Por favor, ingresa valores válidos.';
    }
  }
}
