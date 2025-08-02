import 'package:bidding_bazar/app/constant/api_enpoints.dart';
import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:bidding_bazar/core/network/auth_interceptor.dart';
import 'package:bidding_bazar/core/network/dio_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }

  // Factory constructor to create ApiService with auth interceptor
  factory ApiService.withAuth(Dio dio, TokenSharedPrefs tokenSharedPrefs) {
    final apiService = ApiService(dio);
    apiService._dio.interceptors.add(AuthInterceptor(tokenSharedPrefs));
    return apiService;
  }
}
