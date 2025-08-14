import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;

  const ChangeLanguageEvent({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}

class LoadSavedLanguageEvent extends LanguageEvent {}

// States
class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  @override
  List<Object> get props => [locale];
}

// BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(locale: Locale('sw', 'KE'))) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadSavedLanguageEvent>(_onLoadSavedLanguage);
  }

  void _onChangeLanguage(ChangeLanguageEvent event, Emitter<LanguageState> emit) {
    final locale = _getLocaleFromLanguageCode(event.languageCode);
    emit(LanguageState(locale: locale));
  }

  void _onLoadSavedLanguage(LoadSavedLanguageEvent event, Emitter<LanguageState> emit) async {
    // Simulate loading saved language from storage
    await Future.delayed(const Duration(milliseconds: 100));
    
    // For demo purposes, use Swahili as default
    emit(const LanguageState(locale: Locale('sw', 'KE')));
  }

  Locale _getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'en':
        return const Locale('en', 'US');
      case 'sw':
        return const Locale('sw', 'KE');
      case 'ki':
        return const Locale('ki', 'KE');
      case 'luo':
        return const Locale('luo', 'KE');
      case 'kln':
        return const Locale('kln', 'KE');
      case 'so':
        return const Locale('so', 'KE');
      default:
        return const Locale('sw', 'KE');
    }
  }
}
