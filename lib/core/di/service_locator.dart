import 'package:bidding_bazar/core/api/api_client.dart';
import 'package:bidding_bazar/core/api/socket_client.dart';
import 'package:bidding_bazar/core/storage/session_manager.dart';
import 'package:bidding_bazar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bidding_bazar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bidding_bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/check_auth_status.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/login_user.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/logout_user.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/register_user.dart';
import 'package:bidding_bazar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bidding_bazar/features/create_listing/data/datasources/create_listing_remote_data_source.dart';
import 'package:bidding_bazar/features/create_listing/data/repositories/create_listing_repository_impl.dart';
import 'package:bidding_bazar/features/create_listing/domain/repositories/create_listing_repository.dart';
import 'package:bidding_bazar/features/create_listing/domain/usecases/create_bidding_room.dart';
import 'package:bidding_bazar/features/create_listing/presentation/cubit/create_listing_cubit.dart';
import 'package:bidding_bazar/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:bidding_bazar/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:bidding_bazar/features/notification/domain/repository/notification_repository.dart';
import 'package:bidding_bazar/features/notification/domain/usecases/get_my_notifications.dart';
import 'package:bidding_bazar/features/notification/domain/usecases/mark_notifications_as_read.dart';
import 'package:bidding_bazar/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:bidding_bazar/features/product/data/datasources/product_remote_data_source.dart';
import 'package:bidding_bazar/features/product/data/repositories/product_repository_impl.dart';
import 'package:bidding_bazar/features/product/domain/repositories/product_repository.dart';
import 'package:bidding_bazar/features/product/domain/usecases/get_all_bidding_rooms.dart';
import 'package:bidding_bazar/features/product/domain/usecases/get_bidding_room_by_id.dart';
import 'package:bidding_bazar/features/product/domain/usecases/place_bid.dart';
import 'package:bidding_bazar/features/product/presentation/bloc/product_bloc.dart';
import 'package:bidding_bazar/profile/data/datasources/profile_remote_data_source.dart';
import 'package:bidding_bazar/profile/data/repositories/profile_repository_impl.dart';
import 'package:bidding_bazar/profile/domain/repositories/profile_repository.dart';
import 'package:bidding_bazar/profile/domain/usecases/get_profile_data.dart';
import 'package:bidding_bazar/profile/presentation/bloc/profile_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

// sl is a common abbreviation for Service Locator
final sl = GetIt.instance;

Future<void> setupLocator() async {

  sl.registerFactory(() => AuthBloc(
        loginUser: sl(),
        registerUser: sl(),
        checkAuthStatus: sl(),
        logoutUser: sl(),
      ));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        sessionManager: sl(),
      ));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        apiClient: sl(),
        sessionManager: sl(),
      ));

  sl.registerFactory(() => ProductBloc(
        getAllBiddingRooms: sl(),
        getBiddingRoomById: sl(),
        placeBid: sl(),
      ));
  sl.registerLazySingleton(() => GetAllBiddingRooms(sl()));
  sl.registerLazySingleton(() => GetBiddingRoomById(sl()));
  sl.registerLazySingleton(() => PlaceBid(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
        remoteDataSource: sl(),
      ));
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(
        apiClient: sl(),
      ));


  sl.registerFactory(() => ProfileBloc(getProfileData: sl()));
  sl.registerLazySingleton(() => GetProfileData(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(apiClient: sl()));

  sl.registerFactory(() => CreateListingCubit(sl()));
  sl.registerLazySingleton(() => CreateBiddingRoom(sl()));
  sl.registerLazySingleton<CreateListingRepository>(() => CreateListingRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<CreateListingRemoteDataSource>(() => CreateListingRemoteDataSourceImpl(apiClient: sl()));


  sl.registerFactory(() => NotificationBloc(
    getMyNotifications: sl(),
    markNotificationsAsRead: sl(),
    socketClient: sl(),
  ));
  sl.registerLazySingleton(() => GetMyNotifications(sl()));
  sl.registerLazySingleton(() => MarkNotificationsAsRead(sl()));
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(apiClient: sl()));


  // CORE & EXTERNAL


  // 1. Register External Packages first.
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // 2. Register Core services that depend on the external packages or are singletons.
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => SessionManager(secureStorage: sl()));
  sl.registerLazySingleton(() => SocketClient());
}