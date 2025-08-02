import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final TokenSharedPrefs _tokenSharedPrefs;

  AuthInterceptor(this._tokenSharedPrefs);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from SharedPreferences
    final tokenResult = await _tokenSharedPrefs.getToken();

    tokenResult.fold(
      (failure) {
        // If we can't get the token, continue without it
        handler.next(options);
      },
      (token) {
        if (token != null && token.isNotEmpty) {
          // Add authorization header
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 errors by clearing the token
    if (err.response?.statusCode == 401) {
      _tokenSharedPrefs.clearToken();
    }
    handler.next(err);
  }
}
