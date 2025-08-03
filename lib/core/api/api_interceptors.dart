
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:bidding_bazar/core/storage/session_manager.dart';
import 'package:dio/dio.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await sl<SessionManager>().getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}