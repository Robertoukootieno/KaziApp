import 'package:flutter/material.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/welcome_registration_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/registration_flow_screen.dart';
import 'screens/auth/self_registration_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/profile/profile_setup_screen.dart';
import 'features/veterinary/screens/veterinary_dashboard_screen.dart';
import 'features/machinery/screens/machinery_dashboard_screen.dart';
import 'features/marketplace/screens/marketplace_dashboard_screen.dart';

void main() {
  runApp(const KaziAppServiceProvider());
}

class KaziAppServiceProvider extends StatelessWidget {
  const KaziAppServiceProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaziApp Service Provider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2E7D32)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/welcome-registration': (context) => const WelcomeRegistrationScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationFlowScreen(),
        '/register-simple': (context) => const RegisterScreen(),
        '/self-register': (context) => const SelfRegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/veterinary-dashboard': (context) => const VeterinaryDashboardScreen(),
        '/machinery-dashboard': (context) => const MachineryDashboardScreen(),
        '/marketplace-dashboard': (context) => const MarketplaceDashboardScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
      },
    );
  }
}
