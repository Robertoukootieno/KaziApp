import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Screens
import 'screens/auth/enhanced_login_screen.dart';
import 'screens/auth/email_verification_screen.dart';
import 'navigation/main_navigation.dart';

// BLoC
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Performance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (non-blocking)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Start app immediately without waiting for orientation
  runApp(const KaziApp());
}

class KaziApp extends StatelessWidget {
  const KaziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'KaziApp Mkulima',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32), // Green for agriculture
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
        home: const OptimizedAuthWrapper(),
      ),
    );
  }
}

class OptimizedAuthWrapper extends StatefulWidget {
  const OptimizedAuthWrapper({super.key});

  @override
  State<OptimizedAuthWrapper> createState() => _OptimizedAuthWrapperState();
}

class _OptimizedAuthWrapperState extends State<OptimizedAuthWrapper> {
  bool _showFastSplash = true;

  @override
  void initState() {
    super.initState();
    // Show fast splash immediately, then trigger auth check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuth();
    });
  }

  void _initializeAuth() async {
    // Small delay to show the fast splash
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _showFastSplash = false;
      });

      // Now trigger the auth check
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showFastSplash) {
      return const FastSplashScreen();
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoadingState || state is AuthInitialState) {
          return const SplashScreen();
        } else if (state is AuthenticatedState) {
          return const MainNavigation();
        } else if (state is EmailVerificationRequiredState) {
          return EmailVerificationScreen(
            username: state.username,
            email: state.email,
          );
        } else {
          return const EnhancedLoginScreen();
        }
      },
    );
  }
}

class FastSplashScreen extends StatelessWidget {
  const FastSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple logo without complex decorations
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.agriculture,
                size: 50,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 24),

            // App name
            const Text(
              'KaziApp',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Simple tagline
            const Text(
              'Empowering African Farmers',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),

            // Simple loading indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.agriculture,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 24),

              // App Name
              const Text(
                'KaziApp',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Empowering African Farmers',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),

              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


