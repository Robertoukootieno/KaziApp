import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/offline/presentation/bloc/offline_bloc.dart';
import '../../features/localization/presentation/bloc/language_bloc.dart';
import '../../shared/services/notification_service.dart';
import '../../shared/services/offline_sync_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  getIt.registerSingleton<AppConfig>(AppConfig.instance);
  
  // Services
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<OfflineSyncService>(() => OfflineSyncService());
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(() => AuthBloc());
  getIt.registerFactory<OfflineBloc>(() => OfflineBloc());
  getIt.registerFactory<LanguageBloc>(() => LanguageBloc());
}
