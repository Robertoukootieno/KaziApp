import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../services/keycloak_auth_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginEvent({required this.phoneNumber, required this.password});

  @override
  List<Object> get props => [phoneNumber, password];
}

class LogoutEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String password;
  final String? county;
  final String preferredLanguage;

  const RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.email,
    required this.password,
    this.county,
    this.preferredLanguage = 'en',
  });

  @override
  List<Object> get props => [firstName, lastName, phoneNumber, email ?? '', password, county ?? '', preferredLanguage];
}

class VerifyEmailEvent extends AuthEvent {
  final String userId;
  final String token;

  const VerifyEmailEvent({required this.userId, required this.token});

  @override
  List<Object> get props => [userId, token];
}

class ResendVerificationEvent extends AuthEvent {
  final String username;

  const ResendVerificationEvent({required this.username});

  @override
  List<Object> get props => [username];
}

class CheckVerificationStatusEvent extends AuthEvent {
  final String username;

  const CheckVerificationStatusEvent({required this.username});

  @override
  List<Object> get props => [username];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final String userId;
  final String phoneNumber;
  final UserProfile? user;

  const AuthenticatedState({
    required this.userId,
    required this.phoneNumber,
    this.user,
  });

  @override
  List<Object> get props => [userId, phoneNumber, user ?? ''];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class EmailVerificationRequiredState extends AuthState {
  final String username;
  final String email;
  final UserProfile? user;

  const EmailVerificationRequiredState({
    required this.username,
    required this.email,
    this.user,
  });

  @override
  List<Object> get props => [username, email, user ?? ''];
}

class EmailVerificationSuccessState extends AuthState {
  final UserProfile user;

  const EmailVerificationSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class VerificationEmailSentState extends AuthState {
  final String message;

  const VerificationEmailSentState({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final KeycloakAuthService _authService = KeycloakAuthService();

  AuthBloc() : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<ResendVerificationEvent>(_onResendVerification);
    on<CheckVerificationStatusEvent>(_onCheckVerificationStatus);
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Initialize Keycloak service with timeout
      await _authService.initialize().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('⚠️ Keycloak initialization timeout, proceeding with offline mode');
          throw TimeoutException('Keycloak initialization timeout');
        },
      );

      // Check if user is authenticated
      final isAuthenticated = await _authService.isAuthenticated().timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );

      if (isAuthenticated) {
        final user = await _authService.getCurrentUser().timeout(
          const Duration(seconds: 3),
          onTimeout: () => null,
        );

        if (user != null) {
          emit(AuthenticatedState(
            userId: user.id,
            phoneNumber: user.phoneNumber ?? user.username,
            user: user,
          ));
        } else {
          emit(UnauthenticatedState());
        }
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      debugPrint('⚠️ Auth check failed, proceeding to login: ${e.toString()}');
      // Don't show error, just proceed to login screen
      emit(UnauthenticatedState());
    }
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Authenticate with Keycloak
      final result = await _authService.login(event.phoneNumber, event.password);

      if (result.success && result.user != null) {
        emit(AuthenticatedState(
          userId: result.user!.id,
          phoneNumber: result.user!.phoneNumber ?? result.user!.username,
          user: result.user,
        ));
      } else {
        emit(AuthErrorState(message: result.error ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Login failed: ${e.toString()}'));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Logout from Keycloak
      await _authService.logout();
      emit(UnauthenticatedState());
    } catch (e) {
      // Even if logout fails, clear local state
      emit(UnauthenticatedState());
    }
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Create registration object
      final registration = UserRegistration(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
        confirmPassword: event.password,
        county: event.county,
        preferredLanguage: event.preferredLanguage,
        clientType: 'farmer',
      );

      // Register with Keycloak
      final result = await _authService.register(registration);

      if (result.success && result.user != null) {
        if (result.requiresVerification) {
          emit(EmailVerificationRequiredState(
            username: result.user!.phoneNumber ?? result.user!.username,
            email: result.user!.email ?? '',
            user: result.user,
          ));
        } else {
          emit(AuthenticatedState(
            userId: result.user!.id,
            phoneNumber: result.user!.phoneNumber ?? result.user!.username,
            user: result.user,
          ));
        }
      } else {
        emit(const AuthErrorState(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Registration failed: ${e.toString()}'));
    }
  }

  void _onVerifyEmail(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Verify email with Keycloak
      final result = await _authService.verifyEmail(event.userId, event.token);

      if (result.success && result.user != null) {
        emit(EmailVerificationSuccessState(user: result.user!));
      } else {
        emit(AuthErrorState(message: result.error ?? 'Email verification failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Email verification failed: ${e.toString()}'));
    }
  }

  void _onResendVerification(ResendVerificationEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Resend verification email
      final success = await _authService.resendVerification(event.username);

      if (success) {
        emit(const VerificationEmailSentState(message: 'Verification email sent successfully!'));
      } else {
        emit(const AuthErrorState(message: 'Failed to send verification email'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Failed to send verification email: ${e.toString()}'));
    }
  }

  void _onCheckVerificationStatus(CheckVerificationStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      // Check verification status
      final status = await _authService.getVerificationStatus(event.username);

      if (status != null && status.emailVerified) {
        // Get current user profile
        final user = await _authService.getCurrentUser();
        if (user != null) {
          emit(AuthenticatedState(
            userId: user.id,
            phoneNumber: user.phoneNumber ?? user.username,
            user: user,
          ));
        } else {
          emit(const AuthErrorState(message: 'Failed to get user profile'));
        }
      } else {
        emit(const AuthErrorState(message: 'Email not yet verified'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Failed to check verification status: ${e.toString()}'));
    }
  }
}
