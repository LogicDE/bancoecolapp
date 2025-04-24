import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class CompoundInterestController extends GetxController {
  // Controladores de texto
  final TextEditingController capitalController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController yearsController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController finalAmountController = TextEditingController();

  var capital = 0.0.obs;
  var tasaInteres = 0.0.obs;
  var tiempoEnMeses = 0.obs;
  var capitalizacion = 1.obs; // 1: Anual, 2: Semestral, 4: Trimestral, etc.
  var montoCompuesto = 0.0.obs;
  var intereses = 0.0.obs;

  // Opciones de capitalización
  final Map<String, int> compoundingOptions = {
    "Anual": 1,
    "Semestral": 2,
    "Trimestral": 4,
    "Mensual": 12,
  };

  final Map<String, double> interestTypeOptions = {
    "Anual": 1.0,
    "Semestral": 2.0,
    "Trimestral": 4.0,
    "Mensual": 12.0,
  };

  var compoundingFrequency = 1.obs;
  var selectedInterestType = "Anual".obs; // Tipo de tasa seleccionada

  // Datos para la gráfica
  var chartData = <double>[].obs;

  // Método para actualizar valores desde los TextFields
  void updateValues() {
    capital.value = double.tryParse(capitalController.text) ?? 0.0;
    tasaInteres.value = double.tryParse(interestRateController.text) ?? 0.0;
    montoCompuesto.value = double.tryParse(finalAmountController.text) ?? 0.0;

    // Validar y obtener los valores de años, meses y días
    int years = int.tryParse(yearsController.text) ?? 0;
    int months = int.tryParse(monthsController.text) ?? 0;
    int days = int.tryParse(daysController.text) ?? 0;

    // Convertir el tiempo total a meses (aproximación de días a meses)
    tiempoEnMeses.value = (years * 12) + months + (days ~/ 30);
  }

  void calcularMontoCompuesto() {
    updateValues(); // Asegura que los valores están actualizados

    if (capital.value <= 0 ||
        tasaInteres.value <= 0 ||
        tiempoEnMeses.value <= 0) {
      return; // Evita cálculos con valores inválidos
    }

    // Convertir la tasa de interés ingresada a decimal
    double i = tasaInteres.value / 100; // Ya es mensual, no dividir por 12
    int n = tiempoEnMeses
        .value; // La capitalización es mensual, así que n es simplemente el tiempo en meses

    // Fórmula del interés compuesto
    montoCompuesto.value = capital.value * pow((1 + i), n);
    intereses.value = montoCompuesto.value - capital.value;
    
    // Generar datos para la gráfica
    chartData.assignAll(List.generate(n + 1, (t) {
      return capital.value * pow((1 + i), t);
    }));
  }

  void calcularCapital() {
    updateValues();
    if (montoCompuesto.value <= 0 ||
        tasaInteres.value <= 0 ||
        tiempoEnMeses.value <= 0) {
      return;
    }

    double i = tasaInteres.value /
        (100 * interestTypeOptions[selectedInterestType.value]!);
    int n = (tiempoEnMeses.value *
        interestTypeOptions[selectedInterestType.value]! ~/
        12);

    capital.value = montoCompuesto.value / pow((1 + i), n);
  }

  void calcularTasaInteres() {
    updateValues();

    if (capital.value <= 0 ||
        montoCompuesto.value <= 0 ||
        tiempoEnMeses.value <= 0) {
      tasaInteres.value = 0.0;
      return;
    }

    // Calcular la tasa de interés mensual
    double tasaMensual =
        pow(montoCompuesto.value / capital.value, 1 / tiempoEnMeses.value) - 1;

    // Convertir la tasa mensual al tipo seleccionado
    if (selectedInterestType.value == "Mensual") {
      // Tasa mensual (ya es la tasa base)
      tasaInteres.value = tasaMensual * 100;
    } else if (selectedInterestType.value == "Anual") {
      // Convertir la tasa mensual a anual
      tasaInteres.value = (pow(1 + tasaMensual, 12) - 1) * 100;
    } else if (selectedInterestType.value == "Trimestral") {
      // Convertir la tasa mensual a trimestral (3 meses)
      tasaInteres.value = (pow(1 + tasaMensual, 3) - 1) * 100;
    } else if (selectedInterestType.value == "Semestral") {
      // Convertir la tasa mensual a semestral (6 meses)
      tasaInteres.value = (pow(1 + tasaMensual, 6) - 1) * 100;
    }
  }

  void calcularTiempo() {
    updateValues();

    if (capital.value <= 0 ||
        montoCompuesto.value <= 0 ||
        tasaInteres.value <= 0) {
      return;
    }

    // Obtener la frecuencia de capitalización seleccionada (Mensual = 12)
    int nFrecuencia = compoundingOptions[selectedInterestType.value] ?? 1;

    // Convertir la tasa de interés anual a la tasa efectiva por período
    double i = (tasaInteres.value / 100) / nFrecuencia;

    // Calcular el número de períodos de capitalización
    double n = log(montoCompuesto.value / capital.value) / log(1 + i);

    // Convertir a meses si la tasa es anual
    tiempoEnMeses.value = (n * (12 / nFrecuencia)).toInt();
  }

  // Método para actualizar la frecuencia de capitalización
  void updateCompoundingFrequency(String selected) {
    compoundingFrequency.value = compoundingOptions[selected] ?? 1;
  }

  void updateInterestType(String selected) {
    selectedInterestType.value = selected;
  }

  @override
  void onClose() {
    capitalController.dispose();
    interestRateController.dispose();
    yearsController.dispose();
    monthsController.dispose();
    daysController.dispose();
    finalAmountController.dispose();
    super.onClose();
  }
}
