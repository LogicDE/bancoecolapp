import 'dart:math';
import 'package:get/get.dart';

class GradientsController extends GetxController {
  var presentValue = 0.0.obs;
  var futureValue = 0.0.obs;
  List<double> progression = <double>[].obs;

  // Métodos de Validación
  void _validarMayorQueCero(num valor, String nombreCampo) {
    if (valor <= 0) throw ArgumentError('$nombreCampo debe ser mayor que 0.');
  }

  void _validarMayorIgualCero(num valor, String nombreCampo) {
    if (valor < 0) throw ArgumentError('$nombreCampo no puede ser negativo.');
  }

  void _validarDiferenteDeCero(num valor, String nombreCampo) {
    if (valor == 0) throw ArgumentError('$nombreCampo no puede ser cero.');
  }

  void _validarPrecision(num valor, int maxDecimals, String nombreCampo) {
    final parts = valor.toString().split('.');
    if (parts.length == 2 && parts[1].length > maxDecimals) {
      throw ArgumentError(
          '$nombreCampo no puede tener más de $maxDecimals decimales.');
    }
  }

  void _validarRango(
    num valor,
    String nombreCampo, {
    num min = 0,
    num max = 1e12,
  }) {
    if (valor < min || valor > max) {
      throw ArgumentError('$nombreCampo debe estar entre $min y $max.');
    }
  }

  /// Gradiente Aritmético
  void calcularGradienteAritmetico({
    required double g,
    required double A,
    required int n,
    required double i,
  }) {
    _validarDiferenteDeCero(g, 'Variación (g)');
    _validarMayorQueCero(A, 'Aporte (A)');
    _validarRango(A, 'Aporte (A)', max: 1e12);
    _validarMayorQueCero(n, 'Número de periodos (n)');
    _validarMayorQueCero(i, 'Tasa de interés (i)');
    _validarRango(i, 'Tasa de interés (i)', max: 2.0);
    _validarPrecision(i, 4, 'Tasa de interés (i)');

    double vp = (A * (1 - pow(1 / (1 + i), n)) / i) +
        (g / i) * ((1 - pow(1 / (1 + i), n)) / i - n / pow(1 + i, n));

    double vf =
        (A * (pow(1 + i, n) - 1) / i) + (g / i) * ((pow(1 + i, n) - 1) / i - n);

    presentValue.value = double.parse(vp.toStringAsFixed(0));
    futureValue.value = double.parse(vf.toStringAsFixed(0));

    progression.clear();
    for (int t = 1; t <= n; t++) {
      progression.add(A + (t - 1) * g);
    }
  }

  void calcularGradienteGeometricoCreciente({
    required double g, // Tasa de crecimiento (decimal)
    required double A, // Pago inicial
    required int n, // Número de períodos
    required double i, // Tasa de interés (decimal)
  }) {
    if (g <= 0 || i <= 0 || A <= 0 || n <= 0) {
      print("Todos los valores deben ser positivos y mayores a 0.");
      return;
    }

    double vp;
    double vf;

    if (i == g) {
      vp = (A * n) / (1 + i);
      vf = A * n;
    } else {
      double ratio = (1 + g) / (1 + i);
      vp = A * (1 - pow(ratio, n)) / (i - g);
      vf = A * (pow(1 + g, n) - pow(1 + i, n)) / (g - i);
    }

    presentValue.value = double.parse(vp.toStringAsFixed(2));
    futureValue.value = double.parse(vf.toStringAsFixed(2));

    progression.clear();
    for (int t = 0; t < n; t++) {
      progression.add(A * pow(1 + g, t));
    }
  }

  void calcularGradienteGeometricoDecreciente({
    required double g,
    required double A,
    required int n,
    required double i,
  }) {
    // Validaciones previas...

    double vp, vf;

    // En geometrico decreciente, 'g' es un porcentaje de decrecimiento
    if (i != g) {
      vp = A * ((pow(1 + i, n) - pow(1 - g, n)) / ((i + g) * pow(1 + i, n)));
      vf = A * ((pow(1 + i, n) - pow(1 - g, n)) / (i + g));
    } else {
      vp = A / (1 + i);
      presentValue.value = double.parse(vp.toStringAsFixed(0));
      futureValue.value = 0.0;
      progression.clear();
      return;
    }

    presentValue.value = double.parse(vp.toStringAsFixed(0));
    futureValue.value = double.parse(vf.toStringAsFixed(0));

    progression.clear();
    for (int t = 0; t < n; t++) {
      progression.add(A * pow(1 - g, t));
    }
  }
}
