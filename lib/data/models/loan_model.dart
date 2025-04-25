import 'cuota_model.dart';

class LoanModel {
  final String id; // Esta variable necesita ser inicializada
  final double monto;
  final double tasa;
  final int plazo;
  final String tipo;
  final List<CuotaModel> cuotas;
  final bool aprobado;
  final double saldoPendiente;

  // Constructor para inicializar todos los campos
  LoanModel({
    required this.id,
    required this.monto,
    required this.tasa,
    required this.plazo,
    required this.tipo,
    required this.cuotas,
    required this.aprobado,
    required this.saldoPendiente,
  });
}
