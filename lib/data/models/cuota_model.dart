class CuotaModel {
  final int numero;
  final double valor;
  final DateTime fechaVencimiento;
  bool _pagada; // Usar variable privada

  CuotaModel({
    required this.numero,
    required this.valor,
    required this.fechaVencimiento,
    bool pagada = false,
  }) : _pagada = pagada;

  bool get pagada => _pagada; // Getter

  // Setter o método para marcar como pagada
  void marcarComoPagada() {
    _pagada = true;
  }
}
