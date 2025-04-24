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
import 'presentation/screens/aritmetic_gradient_screen.dart';
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
          name: '/aritmetic-gradient',
          page: () => AritmeticGradientScreen(),
          middlewares: [AuthMiddleware()]
        ),
      ],
    );
  }
}
