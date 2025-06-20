import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / ViewModel
  sl.registerFactory(() => AuthBloc(loginUser: sl(), signUpUser: sl()));

  // Usecases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignUpUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(userBox: sl(), uuid: sl()));

  // External Dependencies
  final userBox = await Hive.openBox<UserModel>('users');
  sl.registerLazySingleton(() => userBox);
  sl.registerLazySingleton(() => const Uuid());
}