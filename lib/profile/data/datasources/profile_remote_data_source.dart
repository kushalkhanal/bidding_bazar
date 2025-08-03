import 'package:bidding_bazar/core/api/api_client.dart';
import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/profile/data/models/profile_data_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileDataModel> getProfileData();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  late final Dio _dio;

  ProfileRemoteDataSourceImpl({required this.apiClient}) {
    _dio = apiClient.instance;
  }

  @override
  Future<ProfileDataModel> getProfileData() async {
    try {
      final response = await _dio.get('/profile');
      if (response.statusCode == 200) {
        return ProfileDataModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException {
      rethrow;
    }
  }
}