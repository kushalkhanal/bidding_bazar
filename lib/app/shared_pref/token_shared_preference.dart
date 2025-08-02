import 'package:bidding_bazar/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      if (token.isEmpty) {
        return Left(SharedPreferencesFailure(message: 'Token cannot be empty'));
      }

      await _sharedPreferences.setString(_tokenKey, token);
      return const Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to save token: $e'),
      );
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString(_tokenKey);
      return Right(token);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to retrieve token: $e'),
      );
    }
  }

  Future<Either<Failure, void>> clearToken() async {
    try {
      await _sharedPreferences.remove(_tokenKey);
      await _sharedPreferences.remove(_userDataKey);
      return const Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to clear token: $e'),
      );
    }
  }

  Future<Either<Failure, bool>> hasToken() async {
    try {
      final token = _sharedPreferences.getString(_tokenKey);
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(
          message: 'Failed to check token existence: $e',
        ),
      );
    }
  }

  Future<Either<Failure, void>> saveUserData(
    Map<String, dynamic> userData,
  ) async {
    try {
      final userDataString = userData.toString();
      await _sharedPreferences.setString(_userDataKey, userDataString);
      return const Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to save user data: $e'),
      );
    }
  }

  Future<Either<Failure, Map<String, dynamic>?>> getUserData() async {
    try {
      final userDataString = _sharedPreferences.getString(_userDataKey);
      if (userDataString == null) return const Right(null);

      // Simple parsing - in a real app you might want to use JSON
      // For now, we'll return null and let the app fetch fresh user data
      return const Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to retrieve user data: $e'),
      );
    }
  }
}
