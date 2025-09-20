import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/enhanced_registration_screen.dart';
import '../../screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const EnhancedRegistrationScreen(),
      ),
    ],
  );
}

// Placeholder screens
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to KaziApp')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Empowering African Farmers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Connect with veterinarians, access market prices,\nand get AI-powered farming insights.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "welcome_fab",
        onPressed: () => AppRouter.router.go('/login'),
        label: const Text('Get Started'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}




