// lib/features/user/data/datasources/user_remote_data_source.dart

import 'dart:convert';
import 'package:bidding_bazar/app/constant/api_enpoints.dart';
import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/core/network/api_service.dart';
import 'package:bidding_bazar/features/auth/data/models/user_api_model.dart';
import 'package:dio/dio.dart';

abstract class IUserRemoteDataSource {
  Future<void> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String number,
  });

  Future<LoginResponseModel> loginUser({
    required String email,
    required String password,
  });

  Future<UserModel> getMe();
}

class UserRemoteDatasource implements IUserRemoteDataSource {
  final ApiService _apiService;
  // Replace with your actual base URL

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String number,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: json.encode({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
          'number': number,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 201) {
        final errorResponse = response.data;
        throw ServerException(
          errorResponse['message'] ?? 'Registration Failed',
        );
      }
      // No data is returned on successful registration, just a success message.
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException(
          'API endpoint not found. Please check if the backend server is running on ${ApiEndpoints.serverAddress}',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException(
          'Connection timeout. Please check your internet connection and server status.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(
          'Unable to connect to server. Please check if the backend is running on ${ApiEndpoints.serverAddress}',
        );
      } else {
        throw ServerException(e.message ?? 'Network error occurred');
      }
    }
  }

  @override
  Future<LoginResponseModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: json.encode({'email': email, 'password': password}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        final errorResponse = response.data;
        throw ServerException(errorResponse['message'] ?? 'Login Failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException(
          'Login endpoint not found. Please check if the backend server is running on ${ApiEndpoints.serverAddress}',
        );
      } else if (e.response?.statusCode == 401) {
        throw ServerException('Invalid email or password');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException(
          'Connection timeout. Please check your internet connection and server status.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(
          'Unable to connect to server. Please check if the backend is running on ${ApiEndpoints.serverAddress}',
        );
      } else {
        throw ServerException(e.message ?? 'Network error occurred');
      }
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getMe,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        final errorResponse = response.data;
        throw ServerException(
          errorResponse['message'] ?? 'Failed to get user data',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw ServerException(
          'User endpoint not found. Please check if the backend server is running on ${ApiEndpoints.serverAddress}',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException(
          'Connection timeout. Please check your internet connection and server status.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(
          'Unable to connect to server. Please check if the backend is running on ${ApiEndpoints.serverAddress}',
        );
      } else {
        throw ServerException(e.message ?? 'Network error occurred');
      }
    }
  }
}
