import 'dart:math';

enum CapitalizationType {
  simple,
  compound,
  continuous,
  periodic,
  anticipada,
  diferida,
}

class CapitalizationRow {
  final int period;
  final double interest;
  final double accumulated;

  CapitalizationRow({
    required this.period,
    required this.interest,
    required this.accumulated,
  });
}

class CapitalizationController {
  List<CapitalizationRow> table = [];

  /// Este será usado por la pantalla para cambiar el tipo desde el dropdown
  CapitalizationType selectedType = CapitalizationType.simple;

  void calculate(double P, double r, int n, int frequency) {
    table.clear();
    r /= 100; // Convertimos el porcentaje a decimal

    switch (selectedType) {
      case CapitalizationType.simple:
        _calculateSimple(P, r, n);
        break;
      case CapitalizationType.compound:
        _calculateCompound(P, r, n, frequency);
        break;
      case CapitalizationType.continuous:
        _calculateContinuous(P, r, n);
        break;
      case CapitalizationType.periodic:
        _calculateCompound(P, r, n, frequency); // Similar a compuesta
        break;
      case CapitalizationType.anticipada:
        _calculateAnticipada(P, r, n);
        break;
      case CapitalizationType.diferida:
        _calculateDiferida(P, r, n, frequency);
        break;
    }
  }

  void _calculateSimple(double P, double r, int n) {
    for (int t = 1; t <= n; t++) {
      double interest = P * r * t;
      double amount = P + interest;
      table.add(CapitalizationRow(period: t, interest: interest, accumulated: amount));
    }
  }

  void _calculateCompound(double P, double r, int n, int m) {
    for (int t = 1; t <= n; t++) {
      double amount = P * pow((1 + (r / m)), (m * t));
      double interest = amount - P;
      table.add(CapitalizationRow(period: t, interest: interest, accumulated: amount));
    }
  }

  void _calculateContinuous(double P, double r, int n) {
    for (int t = 1; t <= n; t++) {
      double amount = P * exp(r * t);
      double interest = amount - P;
      table.add(CapitalizationRow(period: t, interest: interest, accumulated: amount));
    }
  }

  void _calculateAnticipada(double P, double r, int n) {
    for (int t = 1; t <= n; t++) {
      double amount = P * pow((1 + r), t + 1);
      double interest = amount - P;
      table.add(CapitalizationRow(period: t, interest: interest, accumulated: amount));
    }
  }

  void _calculateDiferida(double P, double r, int n, int delay) {
    for (int t = 1; t <= n; t++) {
      if (t <= delay) {
        table.add(CapitalizationRow(period: t, interest: 0, accumulated: P));
      } else {
        double amount = P * pow((1 + r), t - delay);
        double interest = amount - P;
        table.add(CapitalizationRow(period: t, interest: interest, accumulated: amount));
      }
    }
  }
}
