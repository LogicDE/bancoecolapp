import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/screens/sign_up_screen.dart';
import 'presentation/screens/forgotpasswor_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/sign_in_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcolApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/sign-in', // Define la ruta inicial
      getPages: [
        GetPage(
            name: '/sign-in',
            page: () => const SignInPage()), // Página de inicio
        GetPage(name: '/sign-up', page: () => const SignUpPage()),
        GetPage(
            name: '/forgot-password', page: () => const ForgotPasswordPage()),
        GetPage(name: '/dashboard', page: () => const DashboardPage()),
      ],
    );
  }
}
