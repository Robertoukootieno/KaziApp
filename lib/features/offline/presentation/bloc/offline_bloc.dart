import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class OfflineEvent extends Equatable {
  const OfflineEvent();

  @override
  List<Object> get props => [];
}

class CheckConnectivityEvent extends OfflineEvent {}

class ConnectivityChangedEvent extends OfflineEvent {
  final bool isConnected;

  const ConnectivityChangedEvent({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

class SyncDataEvent extends OfflineEvent {}

// States
abstract class OfflineState extends Equatable {
  const OfflineState();

  @override
  List<Object> get props => [];
}

class OfflineInitialState extends OfflineState {}

class OnlineState extends OfflineState {}

class OfflineState extends OfflineState {}

class SyncingState extends OfflineState {}

class SyncCompletedState extends OfflineState {
  final int syncedItems;

  const SyncCompletedState({required this.syncedItems});

  @override
  List<Object> get props => [syncedItems];
}

class SyncErrorState extends OfflineState {
  final String message;

  const SyncErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  OfflineBloc() : super(OfflineInitialState()) {
    on<CheckConnectivityEvent>(_onCheckConnectivity);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);
    on<SyncDataEvent>(_onSyncData);
  }

  void _onCheckConnectivity(CheckConnectivityEvent event, Emitter<OfflineState> emit) async {
    // Simulate connectivity check
    await Future.delayed(const Duration(milliseconds: 500));
    
    // For demo purposes, assume we're online
    emit(OnlineState());
  }

  void _onConnectivityChanged(ConnectivityChangedEvent event, Emitter<OfflineState> emit) {
    if (event.isConnected) {
      emit(OnlineState());
      // Automatically trigger sync when coming back online
      add(SyncDataEvent());
    } else {
      emit(OfflineState());
    }
  }

  void _onSyncData(SyncDataEvent event, Emitter<OfflineState> emit) async {
    emit(SyncingState());
    
    try {
      // Simulate data synchronization
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, assume 5 items were synced
      emit(const SyncCompletedState(syncedItems: 5));
      
      // Return to online state after sync
      await Future.delayed(const Duration(seconds: 1));
      emit(OnlineState());
    } catch (e) {
      emit(SyncErrorState(message: 'Sync failed: ${e.toString()}'));
    }
  }
}
