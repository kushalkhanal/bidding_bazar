import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/storage/session_manager.dart';
import 'package:bidding_bazar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SessionManager sessionManager;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sessionManager,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
      {required String email, required String password}) async {
    try {
      final user = await remoteDataSource.login(email: email, password: password);
      return Right(user);
    } on ServerException {
      return const Left(ServerFailure('An error occurred on the server.'));
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessageFromDioException(e)));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String number,
  }) async {
    try {
      await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        number: number,
      );
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Registration failed. Please try again.'));
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessageFromDioException(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkAuthStatus() async {
    try {
      final token = await sessionManager.getToken();
      if (token == null) {
        return const Left(CacheFailure('No token found'));
      }
      
      final user = await remoteDataSource.getMe();
      return Right(user);
    } on ServerException {
      await sessionManager.deleteToken();
      return const Left(ServerFailure('Session expired. Please log in again.'));
    } on CacheException {
       return const Left(CacheFailure('Could not retrieve token.'));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await sessionManager.deleteToken();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Could not log out.'));
    }
  }

  String _getErrorMessageFromDioException(DioException e) {
    String errorMessage = 'An unknown error occurred.';

    if (e.response?.data != null) {
      final responseData = e.response!.data;
      
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
      } 
      else if (responseData is String && responseData.isNotEmpty) {
        errorMessage = responseData;
      }
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timed out. Please check your internet connection.';
          break;
        case DioExceptionType.connectionError:
           errorMessage = 'Connection error. Please check your internet connection.';
           break;
        default:
          errorMessage = 'An unexpected network error occurred.';
      }
    }
    return errorMessage;
  }
}