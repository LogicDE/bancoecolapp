import 'package:bancosbase/data/models/cuota_model.dart';
import 'package:bancosbase/presentation/controllers/loan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanSummaryPage extends StatefulWidget {
  @override
  _LoanSummaryPageState createState() => _LoanSummaryPageState();
}

class _LoanSummaryPageState extends State<LoanSummaryPage> {
  final LoanController _loanController = Get.put(LoanController());

  @override
  void initState() {
    super.initState();
    // Llamar a los métodos para obtener los datos al inicio
    _loanController.obtenerHistorialPrestamos();
    _loanController.obtenerSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Préstamos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Recargar manualmente si es necesario
              _loanController.obtenerHistorialPrestamos();
              _loanController.obtenerSaldo();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_loanController.historialPrestamos.isEmpty) {
          return Center(child: Text('No tienes préstamos registrados'));
        }

        return Column(
          children: [
            // Mostrar saldo disponible
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saldo Disponible:', style: TextStyle(fontSize: 18)),
                    Text(
                      '\$${_loanController.saldoDisponible.value.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            // Lista de préstamos
            Expanded(
              child: ListView.builder(
                itemCount: _loanController.historialPrestamos.length,
                itemBuilder: (context, index) {
                  final prestamo = _loanController.historialPrestamos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                          'Préstamo \$${prestamo['monto'].toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${prestamo['tipoInteres'] == 'simple' ? 'Interés Simple' : 'Interés Compuesto'} - ${prestamo['tasa']}%'),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLoanDetailItem('Monto:',
                                  '\$${prestamo['monto'].toStringAsFixed(2)}'),
                              _buildLoanDetailItem(
                                  'Tasa:', '${prestamo['tasa']}%'),
                              _buildLoanDetailItem(
                                  'Plazo:', '${prestamo['tiempo']} año(s)'),
                              _buildLoanDetailItem('Cuota Mensual:',
                                  '\$${prestamo['cuotaMensual'].toStringAsFixed(2)}'),
                              _buildLoanDetailItem('Total a Pagar:',
                                  '\$${prestamo['totalAPagar'].toStringAsFixed(2)}'),
                              _buildLoanDetailItem('Fecha:',
                                  '${prestamo['fechaSolicitud'].toString().substring(0, 10)}'),
                              SizedBox(height: 16),
                              // Botones para pagar total o cuota
                              ElevatedButton(
                                onPressed: () => _pagarTotalPrestamo(
                                    context, prestamo['totalAPagar']),
                                child: Text('Pagar Total'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: Size(double.infinity, 50)),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _pagarCuotaMensual(context),
                                child: Text('Pagar Cuota Mensual'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity, 50)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoanDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _pagarTotalPrestamo(BuildContext context, double totalAPagar) {
    double cantidad = totalAPagar; // Esta es la cantidad que se paga

    // Aseguramos que el saldo no quede negativo
    if (_loanController.saldoDisponible.value >= cantidad) {
      // Llamamos al método para reducir el préstamo
      _loanController.reducirPrestamo(cantidad);

      // Actualizar UI o notificación
      Get.snackbar(
        "Pago Realizado",
        "El total del préstamo ha sido reducido.",
        backgroundColor: Colors.green,
      );

      // Si ya no hay saldo pendiente, marcar como préstamo pagado
      if (_loanController.saldoDisponible.value == 0) {
        Get.snackbar(
          "Préstamo Completado",
          "El préstamo ha sido pagado en su totalidad.",
          backgroundColor: Colors.blue,
        );
      }
    } else {
      Get.snackbar(
        "Saldo Insuficiente",
        "No tienes suficiente saldo para realizar el pago total.",
        backgroundColor: Colors.red,
      );
    }
  }

  void _pagarCuotaMensual(BuildContext context) {
    List<CuotaModel> cuotasPendientes =
        _loanController.cuotas.where((cuota) => !cuota.pagada).toList();

    if (cuotasPendientes.isNotEmpty) {
      var cuota = cuotasPendientes.first;

      if (_loanController.saldoDisponible.value >= cuota.valor) {
        // Actualizar el saldo disponible
        _loanController.saldoDisponible.value -= cuota.valor;

        // Marcar la cuota como pagada
        _loanController.marcarCuotaComoPagada(cuota.numero - 1);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cuota #${cuota.numero} pagada exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saldo insuficiente para pagar esta cuota')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay cuotas pendientes')),
      );
    }
  }
}
