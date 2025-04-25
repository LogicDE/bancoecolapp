import 'dart:math'; // Importar dart:math para usar pow
import 'package:bancosbase/data/models/cuota_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoanController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var monto = 0.0.obs;
  var tasa = 0.0.obs;
  var tiempo = 0.obs;
  var tipoInteres = TipoInteres.simple.obs;
  var cuotaMensual = 0.0.obs;
  var totalAPagar = 0.0.obs;
  var saldoDisponible = 0.0.obs; // Saldo disponible para pagos

  // Listas para almacenar los datos de los préstamos y cuotas
  var cuotas = <CuotaModel>[].obs;
  var historialPrestamos = <Map<String, dynamic>>[].obs;
  var cuotasSeleccionadas = <int>[].obs;

  // Esta función debe calcular la cuota mensual y el total a pagar
  void calcularPrestamo() {
    if (tipoInteres.value == TipoInteres.simple) {
      // Fórmula de interés simple
      double interes = monto.value * (tasa.value / 100) * tiempo.value;
      cuotaMensual.value = (monto.value + interes) / (tiempo.value * 12);
      totalAPagar.value = monto.value + interes;

      // Generar las cuotas para cada mes
      cuotas.clear();
      for (int i = 1; i <= tiempo.value * 12; i++) {
        cuotas.add(CuotaModel(
          numero: i,
          valor: cuotaMensual.value,
          fechaVencimiento: DateTime.now().add(Duration(days: i * 30)),
        ));
      }
    } else {
      // Interés compuesto con fórmula tipo francés (cuota fija mensual)
      double tasaMensual = (tasa.value / 100) / 12;
      int numeroPagos = tiempo.value * 12;

      double numerador = tasaMensual * pow(1 + tasaMensual, numeroPagos);
      double denominador = pow(1 + tasaMensual, numeroPagos) - 1;

      cuotaMensual.value = monto.value * (numerador / denominador);
      totalAPagar.value = cuotaMensual.value * numeroPagos;

      // Generar las cuotas para cada mes
      cuotas.clear();
      for (int i = 1; i <= numeroPagos; i++) {
        cuotas.add(CuotaModel(
          numero: i,
          valor: cuotaMensual.value,
          fechaVencimiento: DateTime.now().add(Duration(days: i * 30)),
        ));
      }
    }
  }

  Future<void> obtenerSaldo() async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        var doc = await _firestore.collection('users').doc(user.uid).get();
        saldoDisponible.value = doc['saldo'] ?? 0.0;
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo obtener el saldo.",
          backgroundColor: Colors.red);
    }
  }

  void marcarCuotaComoPagada(int index) async {
    var cuota = cuotas[index];

    if (!cuota.pagada) {
      if (saldoDisponible.value >= cuota.valor) {
        cuota.marcarComoPagada();
        cuotas.refresh();

        var user = _auth.currentUser;
        if (user != null) {
          final userDocRef = _firestore.collection('users').doc(user.uid);

          await _firestore.runTransaction((transaction) async {
            final snapshot = await transaction.get(userDocRef);
            double saldoActual = snapshot.get('saldo') ?? 0.0;

            if (saldoActual >= cuota.valor) {
              // 1. Registrar cuota pagada
              await _firestore.collection('cuotasPagadas').add({
                'userId': user.uid,
                'cuotaNumero': cuota.numero,
                'valor': cuota.valor,
                'fechaPago': FieldValue.serverTimestamp(),
              });

              // 2. Restar saldo
              double nuevoSaldo = saldoActual - cuota.valor;
              transaction.update(userDocRef, {'saldo': nuevoSaldo});
              saldoDisponible.value = nuevoSaldo;

              Get.snackbar("Éxito", "Cuota #${cuota.numero} pagada.",
                  backgroundColor: Colors.green);
            } else {
              throw Exception("Saldo insuficiente durante la transacción.");
            }
          });
        }
      } else {
        Get.snackbar("Error", "Saldo insuficiente para pagar esta cuota.",
            backgroundColor: Colors.red);
      }
    } else {
      Get.snackbar("Info", "Esta cuota ya está pagada.",
          backgroundColor: Colors.orange);
    }
  }

  // Función para solicitar el préstamo y guardarlo en Firestore
  Future<void> solicitarPrestamo() async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        // 1. Guardar préstamo
        await FirebaseFirestore.instance.collection('loans').add({
          'monto': monto.value,
          'tasa': tasa.value,
          'tiempo': tiempo.value,
          'tipoInteres':
              tipoInteres.value == TipoInteres.simple ? 'simple' : 'compuesto',
          'cuotaMensual': cuotaMensual.value,
          'totalAPagar': totalAPagar.value,
          'usuarioId': user.uid,
          'fechaSolicitud': FieldValue.serverTimestamp(),
        });

        // 2. Actualizar el saldo en Firestore
        final userDocRef = _firestore.collection('users').doc(user.uid);

        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(userDocRef);
          double saldoActual = snapshot.get('saldo') ?? 0.0;
          double nuevoSaldo = saldoActual + monto.value;

          transaction.update(userDocRef, {'saldo': nuevoSaldo});
          saldoDisponible.value = nuevoSaldo; // Actualizar localmente también
        });

        Get.snackbar("Éxito", "Préstamo solicitado correctamente",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      }
    } catch (e) {
      Get.snackbar("Error", "Hubo un problema con la solicitud del préstamo",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  void marcarTodoComoPagado() {
    // Marcar todas las cuotas como pagadas
    for (var cuota in cuotas) {
      cuota.marcarComoPagada();
    }
    cuotas.refresh();

    // Actualizar Firestore para reflejar el pago completo
    var user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);

      _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        double saldoActual = snapshot.get('saldo') ?? 0.0;
        double totalAPagar = this.totalAPagar.value;

        if (saldoActual >= totalAPagar) {
          // Restar saldo
          double nuevoSaldo = saldoActual - totalAPagar;
          transaction.update(userDocRef, {'saldo': nuevoSaldo});
          saldoDisponible.value = nuevoSaldo;
        } else {
          throw Exception(
              "Saldo insuficiente para pagar el préstamo completo.");
        }
      });
    }
  }

// Método para reducir el préstamo o pago de cuota
  Future<void> reducirPrestamo(double cantidad) async {
    var user = _auth.currentUser;
    if (user != null) {
      // Obtener el préstamo del usuario
      var prestamosSnapshot = await _firestore
          .collection('loans')
          .where('usuarioId', isEqualTo: user.uid)
          .get();

      if (prestamosSnapshot.docs.isNotEmpty) {
        var prestamoDoc = prestamosSnapshot.docs.first;
        var totalAPagar = prestamoDoc['totalAPagar'];
        var montoRestante = totalAPagar - cantidad;

        // Actualizar el valor restante a pagar
        await _firestore.collection('loans').doc(prestamoDoc.id).update({
          'totalAPagar': montoRestante,
        });

        Get.snackbar("Éxito", "Préstamo actualizado correctamente.",
            backgroundColor: Colors.green);

        // Actualiza el saldo disponible
        await _actualizarSaldoDisponible(cantidad);
      } else {
        Get.snackbar("Error", "No se encontró el préstamo del usuario.",
            backgroundColor: Colors.red);
      }
    }
  }

  Future<void> _actualizarSaldoDisponible(double cantidad) async {
    var user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);
        double saldoActual = snapshot.get('saldo') ?? 0.0;
        double nuevoSaldo = saldoActual - cantidad;

        // Actualizar el saldo en Firestore
        transaction.update(userDocRef, {'saldo': nuevoSaldo});
        saldoDisponible.value = nuevoSaldo; // Actualizar localmente
      });
    }
  }

  // Obtener el historial de préstamos del usuario
  Future<void> obtenerHistorialPrestamos() async {
    try {
      var user = _auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "No estás autenticado.",
            backgroundColor: Colors.red);
        return;
      }

      final querySnapshot = await _firestore
          .collection('loans')
          .where('usuarioId', isEqualTo: user.uid)
          .get();
      historialPrestamos.value = querySnapshot.docs
          .map((doc) => {
                'monto': doc['monto'],
                'tasa': doc['tasa'],
                'tiempo': doc['tiempo'],
                'tipoInteres': doc['tipoInteres'],
                'cuotaMensual': doc['cuotaMensual'],
                'totalAPagar': doc['totalAPagar'],
                'fechaSolicitud': (doc['fechaSolicitud'] as Timestamp).toDate(),
              })
          .toList();
    } catch (e) {
      Get.snackbar("Error",
          "No se pudo cargar el historial de préstamos: ${e.toString()}",
          backgroundColor: Colors.red);
    }
  }
}

enum TipoInteres { simple, compuesto }
