import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  /// REGISTRAR USUARIO CON CÉDULA
  Future<void> signUp(String cedula, String email, String password) async {
    try {
      isLoading.value = true;

      // Verificar si la cédula ya está registrada
      var cedulaExists = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (cedulaExists.docs.isNotEmpty) {
        throw Exception("Esta cédula ya está registrada.");
      }

      // Crear usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar usuario en Firestore con la cédula
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'cedula': cedula,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'saldo': 0.0,
      });

      Get.snackbar("Éxito", "Cuenta creada correctamente",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);

      Get.offAllNamed('/home'); // Redirigir al usuario
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// INICIAR SESIÓN CON CÉDULA Y CONTRASEÑA
  Future<void> signIn(String cedula, String password) async {
    try {
      isLoading.value = true;

      // Buscar email asociado a la cédula en Firestore
      var userQuery = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("No existe una cuenta con esta cédula.");
      }

      String email = userQuery.docs.first['email'];

      // Iniciar sesión con el email recuperado
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.offAllNamed('/dashboard'); // Redirigir a la pantalla principal
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// CERRAR SESIÓN
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/sign-in');
  }

  /// RECUPERAR CONTRASEÑA BASADO EN CÉDULA
  Future<bool> resetPassword(String cedula) async {
    try {
      var userQuery = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("No se encontró un usuario con esta cédula.");
      }

      String email = userQuery.docs.first['email'];
      await _auth.sendPasswordResetEmail(email: email);

      Get.snackbar("Éxito", "Correo de recuperación enviado",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);

      return true; // Indicar que fue exitoso
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
      return false; // Indicar que falló
    }
  }
}
