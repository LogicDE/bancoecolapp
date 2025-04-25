import 'dart:math';
import 'package:get/get.dart';

class TirController extends GetxController {
  var tir = 0.0.obs;
  var iterationsUsed = 0.obs;

  /// Validaciones
  void _validarMayorQueCero(num valor, String nombreCampo) {
    if (valor <= 0) throw ArgumentError('$nombreCampo debe ser mayor que 0.');
  }

  void _validarMayorIgualCero(num valor, String nombreCampo) {
    if (valor < 0) throw ArgumentError('$nombreCampo no puede ser negativo.');
  }

  void _validarListaNoVacia(List lista, String nombreCampo) {
    if (lista.isEmpty) throw ArgumentError('$nombreCampo no debe estar vacío.');
  }

  /// Cálculo de Tasa Interna de Retorno (TIR)
  void calcularTIR({
    required List<double> flujos,
    double estimacionInicial = 0.05,
    double tolerancia = 1e-4,
    int maxIteraciones = 1200,
  }) {
    _validarMayorQueCero(estimacionInicial, 'Estimación inicial');
    _validarMayorIgualCero(tolerancia, 'Tolerancia');
    _validarMayorQueCero(maxIteraciones, 'Máximo de iteraciones');
    _validarListaNoVacia(flujos, 'Lista de flujos de caja');

    double tasa = estimacionInicial;

    for (int i = 0; i < flujos.length; i++) {
      _validarPrecision(flujos[i], 6, 'Flujo de caja en la posición $i');
    }

    for (int i = 0; i < maxIteraciones; i++) {
      double f = 0.0;
      double df = 0.0;

      for (int t = 0; t < flujos.length; t++) {
        f += flujos[t] / pow(1 + tasa, t);
        df += -t * flujos[t] / pow(1 + tasa, t + 1);
      }

      double nuevaTasa = tasa - f / df;

      if ((nuevaTasa - tasa).abs() < tolerancia) {
        tir.value = double.parse(nuevaTasa.toStringAsFixed(6));
        iterationsUsed.value = i + 1;
        return;
      }

      tasa = nuevaTasa;
    }

    throw Exception(
        'No se encontró la TIR después de $maxIteraciones iteraciones');
  }

  void _validarPrecision(num valor, int maxDecimals, String nombreCampo) {
    final parts = valor.toString().split('.');
    if (parts.length == 2 && parts[1].length > maxDecimals) {
      throw ArgumentError(
          '$nombreCampo no puede tener más de $maxDecimals decimales.');
    }
  }
}
