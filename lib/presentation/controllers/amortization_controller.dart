import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class AmortizationRow {
  final int period;
  final double payment;
  final double interest;
  final double amortization;
  final double balance;

  AmortizationRow({
    required this.period,
    required this.payment,
    required this.interest,
    required this.amortization,
    required this.balance,
  });
}

class AmortizationController extends GetxController {
  var type = ''.obs;
  var table = <AmortizationRow>[].obs;

  // Nuevos controladores de entrada
  final capitalCtrl = TextEditingController(text: "10000");
  final rateCtrl = TextEditingController(text: "5"); // porcentaje
  final periodsCtrl = TextEditingController(text: "60");

  void setType(String newType) {
    type.value = newType;
  }

  void calculate() {
    final double principal = double.tryParse(capitalCtrl.text) ?? 0;
    final double rate = (double.tryParse(rateCtrl.text) ?? 0) / 100; // a decimal
    final int periods = int.tryParse(periodsCtrl.text) ?? 1;

    switch (type.value) {
      case 'alemana':
        _calculateGerman(principal, rate, periods);
        break;
      case 'francesa':
        _calculateFrench(principal, rate, periods);
        break;
      case 'americana':
        _calculateAmerican(principal, rate, periods);
        break;
    }
  }

  void _calculateGerman(double P, double r, int n) {
    table.clear();
    double amort = P / n;
    double saldo = P;

    for (int i = 1; i <= n; i++) {
      double interes = saldo * r;
      double cuota = amort + interes;
      saldo -= amort;

      table.add(AmortizationRow(
        period: i,
        payment: cuota,
        interest: interes,
        amortization: amort,
        balance: saldo < 0 ? 0 : saldo,
      ));
    }
  }

  void _calculateFrench(double P, double r, int n) {
    table.clear();
    double tasaMensual = r / 12;
    double cuota = (P * tasaMensual) / (1 - pow(1 + tasaMensual, -n));
    double saldo = P;

    for (int i = 1; i <= n; i++) {
    double interes = saldo * tasaMensual;
    double amort = cuota - interes;
    saldo -= amort;

      table.add(AmortizationRow(
        period: i,
        payment: cuota,
        interest: interes,
        amortization: amort,
        balance: saldo < 0 ? 0 : saldo,
      ));
    }
  }

  void _calculateAmerican(double P, double r, int n) {
    table.clear();

    // Interés fijo cada periodo (mismo saldo hasta el final)
    double interesFijo = P * r;

    for (int i = 1; i <= n; i++) {
      double interes = interesFijo;
      double amort = (i == n) ? P : 0;
      double pago = interes + amort;
      double saldo = (i == n) ? 0 : P;

      table.add(AmortizationRow(
        period: i,
        payment: pago,
        interest: interes,
        amortization: amort,
        balance: saldo,
      ));
    }
  }
}
