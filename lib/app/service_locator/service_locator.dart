import 'package:bidding_bazar/core/network/hive_service.dart';
import 'package:bidding_bazar/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:bidding_bazar/features/auth/data/repository/user_local_repository.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/signup_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:bidding_bazar/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:get_it/get_it.dart';


final serviceLocator = GetIt.instance;

Future initDependencies() async {
  _initHiveService();
  _initSplashModule();
  _initLoginModule();
  _initSignupModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(
    () => UserLoginUsecase(repository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future _initSignupModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDataSource: serviceLocator<UserLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(repository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => SignupViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}

// Future _initHomeModule() async {
//   serviceLocator.registerLazySingleton(() => HomeViewModel());
// }