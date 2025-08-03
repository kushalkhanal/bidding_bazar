import 'package:bidding_bazar/core/api/api_client.dart';
import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/storage/session_manager.dart';
import 'package:bidding_bazar/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String number,
  });
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final SessionManager sessionManager;
  late final Dio _dio;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.sessionManager,
  }) {
    _dio = apiClient.instance;
  }

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      
      // Add robust type checking here, at the first point of contact with the API data.
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final token = response.data['token'] as String?;
        final userMap = response.data['user'];

        if (token != null && userMap is Map<String, dynamic>) {
          await sessionManager.saveToken(token);
          return UserModel.fromJson(userMap);
        }
      }

      throw ServerException();

    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String number,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'number': number
        },
      );
      
      if (response.statusCode != 201) {
        throw ServerException();
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('/users/me');

      // Add robust type checking here as well.
      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['user'] is Map<String, dynamic>) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException();
      }
    } on DioException {
      rethrow;
    }
  }
}