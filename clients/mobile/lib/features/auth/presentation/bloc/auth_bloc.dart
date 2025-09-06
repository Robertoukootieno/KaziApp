import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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
  final String password;

  const RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, phoneNumber, password];
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

  const AuthenticatedState({required this.userId, required this.phoneNumber});

  @override
  List<Object> get props => [userId, phoneNumber];
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<RegisterEvent>(_onRegister);
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    
    // Simulate checking stored auth token
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo purposes, always emit unauthenticated
    emit(UnauthenticatedState());
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, accept any credentials
      emit(AuthenticatedState(
        userId: '123',
        phoneNumber: event.phoneNumber,
      ));
    } catch (e) {
      emit(AuthErrorState(message: 'Login failed: ${e.toString()}'));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    
    // Simulate logout process
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(UnauthenticatedState());
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, always succeed
      emit(AuthenticatedState(
        userId: '123',
        phoneNumber: event.phoneNumber,
      ));
    } catch (e) {
      emit(AuthErrorState(message: 'Registration failed: ${e.toString()}'));
    }
  }
}
