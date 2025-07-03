import 'package:bidding_bazar/app/constant/api_enpoints.dart';
import 'package:bidding_bazar/core/network/api_service.dart';
import 'package:bidding_bazar/features/auth/data/data_source/user_data_source.dart';
import 'package:bidding_bazar/features/auth/data/models/user_api_model.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        final str = response.data["token"] as String;
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception("Failed to login user: ${e.message}");
    } catch (e) {
      throw Exception("Failed to login user: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity userdata) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userdata);
      await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      return; 

    } on DioException catch (e) {
      throw Exception("API Error on registration: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}