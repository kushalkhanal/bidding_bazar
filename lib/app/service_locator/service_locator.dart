import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:bidding_bazar/core/network/api_service.dart';
import 'package:bidding_bazar/core/network/hive_service.dart';
import 'package:bidding_bazar/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:bidding_bazar/features/auth/data/repository/remote_repository/user_remote_repository_impl.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/signup_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:bidding_bazar/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


final serviceLocator = GetIt.instance;

Future initDependencies() async {
  _initHiveService();
  _initSplashModule();
  _initLoginModule();
  _initSharedPref();
  _initApiServices();
  _initSignupModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}
Future<void> _initSharedPref()async{
  final sharedPref = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(()=>sharedPref);
  serviceLocator.registerLazySingleton(
    ()=>TokenSharedPrefs(sharedPreferences: serviceLocator<SharedPreferences>(),)
  );
}

Future<void> _initApiServices()async{
  serviceLocator.registerLazySingleton(()=>ApiService(Dio()));
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(
    () => UserLoginUsecase(repository: serviceLocator<UserRemoteRepositoryImpl>(),tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future _initSignupModule() async {
  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepositoryImpl(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(repository: serviceLocator<UserRemoteRepositoryImpl>()),
  );

  serviceLocator.registerFactory(
    () => SignupViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}

// Future _initHomeModule() async {
//   serviceLocator.registerLazySingleton(() => HomeViewModel());
// }