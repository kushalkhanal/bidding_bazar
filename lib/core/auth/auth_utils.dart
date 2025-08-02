import 'dart:convert';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';

class AuthUtils {
  /// Validates if a JWT token is properly formatted
  static bool isValidJWTFormat(String token) {
    if (token.isEmpty) return false;

    // JWT tokens have 3 parts separated by dots
    final parts = token.split('.');
    if (parts.length != 3) return false;

    // Each part should be base64 encoded
    try {
      for (final part in parts) {
        if (part.isEmpty) return false;
        // Try to decode each part to ensure it's valid base64
        utf8.decode(base64Url.decode(base64Url.normalize(part)));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extracts user data from JWT token payload
  /// Note: This is a basic implementation. In production, you should validate the token signature
  static UserEntity? extractUserFromToken(String token) {
    try {
      if (!isValidJWTFormat(token)) return null;

      final parts = token.split('.');
      final payload = parts[1];

      // Decode the payload
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = json.decode(decodedPayload) as Map<String, dynamic>;

      // Extract user information from payload based on your backend structure
      final userId = payloadMap['userId']?.toString() ?? '';
      final firstName = payloadMap['firstName']?.toString() ?? '';
      final role = payloadMap['role']?.toString() ?? 'user';

      if (userId.isEmpty || firstName.isEmpty) return null;

      // Create a minimal user entity from token data
      // Note: Token doesn't contain all user data, so we'll use placeholders
      // In a real app, you might want to fetch complete user data from API
      return UserEntity(
        id: userId,
        email: '', // Not available in token
        firstName: firstName,
        lastName: '', // Not available in token
        number: '', // Not available in token
        role: role,
        wallet: 0, // Not available in token
      );
    } catch (e) {
      // If any error occurs during parsing, return null
      return null;
    }
  }

  /// Checks if a JWT token is expired
  static bool isTokenExpired(String token) {
    try {
      if (!isValidJWTFormat(token)) return true;

      final parts = token.split('.');
      final payload = parts[1];

      // Decode the payload
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = json.decode(decodedPayload) as Map<String, dynamic>;

      // Check expiration
      final exp = payloadMap['exp'];
      if (exp == null) return true;

      final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final currentTime = DateTime.now();

      return currentTime.isAfter(expirationTime);
    } catch (e) {
      // If any error occurs, consider the token expired
      return true;
    }
  }

  /// Validates a token and returns user data if valid
  static UserEntity? validateTokenAndGetUser(String token) {
    if (!isValidJWTFormat(token)) return null;
    if (isTokenExpired(token)) return null;

    return extractUserFromToken(token);
  }
}
