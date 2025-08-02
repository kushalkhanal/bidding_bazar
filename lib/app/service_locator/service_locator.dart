import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:bidding_bazar/core/auth/auth_bloc.dart';
import 'package:bidding_bazar/core/network/api_service.dart';
import 'package:bidding_bazar/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:bidding_bazar/features/auth/data/repository/remote_repository/user_remote_repository_impl.dart';
// Note: I'm using the file names from our previous chat for consistency
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/signup_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:bidding_bazar/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // =======================================================================
  // External Packages (Lowest level dependencies)
  // =======================================================================
  final sharedPref = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPref);

  // Register Dio
  serviceLocator.registerLazySingleton(() => Dio());

  // Register TokenSharedPrefs
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );

  // Register ApiService with auth interceptor
  serviceLocator.registerLazySingleton(
    () => ApiService.withAuth(
      serviceLocator<Dio>(),
      serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // =======================================================================
  // Core: Auth Bloc
  // =======================================================================
  serviceLocator.registerLazySingleton(
    () => AuthBloc(tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );

  // =======================================================================
  // Feature: Auth
  // =======================================================================
  _initAuthFeature();

  // =======================================================================
  // Feature: Splash
  // =======================================================================
  serviceLocator.registerFactory(() => SplashViewModel());
}

void _initAuthFeature() {
  // -- Data Layer --
  // Register DataSource (depends on Dio)
  // Use Real DataSource for production
  serviceLocator.registerLazySingleton<IUserRemoteDataSource>(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Register Repository (depends on DataSource)
  serviceLocator.registerLazySingleton<IUserRepository>(
    () => UserRemoteRepository(
      remoteDataSource: serviceLocator<IUserRemoteDataSource>(),
    ),
  );

  // -- Domain Layer --
  // Register UseCases (depend on Repository)
  serviceLocator.registerLazySingleton(
    () => LoginUserUsecase(serviceLocator<IUserRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => SignupUserUsecase(serviceLocator<IUserRepository>()),
  );

  // -- Presentation Layer --
  // Register ViewModels (depend on UseCases)
  serviceLocator.registerFactory(
    () => LoginViewModel(
      loginUserUsecase: serviceLocator(),
      authBloc: serviceLocator<AuthBloc>(),
    ),
  );
  serviceLocator.registerFactory(
    () => SignupViewModel(serviceLocator<SignupUserUsecase>()),
  );
}
