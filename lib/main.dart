import 'package:bancosbase/presentation/screens/loans/loan_history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/screens/sign_up_screen.dart';
import 'presentation/screens/forgotpasswor_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/sign_in_screen.dart';
import 'presentation/screens/simple_interest_screen.dart';
import 'presentation/screens/interest_rate_screen.dart';
import 'presentation/screens/annuity_screen.dart';
import 'presentation/screens/compound_interest_screen.dart';
import 'presentation/screens/gradients_screen.dart';
import 'presentation/screens/tir_screen.dart';
import 'presentation/screens/loans/loan_summary_page.dart';
import 'presentation/screens/loans/loan_application_page.dart';
import 'presentation/screens/loans/loan_menu_page.dart';
import 'presentation/screens/loans/loan_report_page.dart';
import 'firebase_options.dart';
import 'core/middlewares/auth_middleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcolApp',
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/dashboard',
      getPages: [
        GetPage(name: '/sign-in', page: () => SignInPage()),
        GetPage(name: '/sign-up', page: () => SignUpPage()),
        GetPage(name: '/forgot-password', page: () => ForgotPasswordPage()),
        GetPage(
            name: '/dashboard',
            page: () => DashboardPage(),
            middlewares: [AuthMiddleware()]), // Protección con middleware
        GetPage(
            name: '/simple-interest',
            page: () => const SimpleInterestScreen(),
            middlewares: [AuthMiddleware()]), // Protección con middleware
        GetPage(
          name: '/interest-rate',
          page: () => InterestRateScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
            name: '/annuities',
            page: () => AnnuitiesPage(),
            middlewares: [AuthMiddleware()]), // Protección con middleware
        GetPage(
          name: '/compound-interest',
          page: () => CompoundInterestScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/gradients', // Ruta para la nueva página
          page: () => GradientsPage(),
          middlewares: [AuthMiddleware()], // Protege la página si es necesario
        ),
        GetPage(
          name: '/tir', // Ruta para la nueva página
          page: () => TirPage(),
          middlewares: [AuthMiddleware()], // Protege la página si es necesario
        ),
        GetPage(
          name: '/loan-menu', // Ruta para la página de préstamos
          page: () => LoanMenuPage(), // La clase que muestra los préstamos
          middlewares: [AuthMiddleware()], // Protección si es necesario
        ),
        GetPage(
          name: '/loan-application', // Ruta para la nueva página
          page: () => LoanApplicationPage(),
          middlewares: [AuthMiddleware()], // Protege la página si es necesario
        ),
        GetPage(
          name: '/loan-report', // Ruta para la nueva página
          page: () => LoanReportPage(),
          middlewares: [AuthMiddleware()], // Protege la página si es necesario
        ),
        GetPage(
          name: '/loan-summary', // Ruta para la nueva página
          page: () => LoanSummaryPage(),
          middlewares: [AuthMiddleware()], // Protege la página si es necesario
        ),
        GetPage(
          name: '/loan-history', // Ruta para la nueva página
          page: () => LoanHistoryPage(),
          middlewares: [AuthMiddleware()], // Protege la página si es necesario
        ),
      ],
    );
  }
}
