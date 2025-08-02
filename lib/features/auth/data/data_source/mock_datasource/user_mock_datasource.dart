import 'package:bidding_bazar/core/error/exceptions.dart';
import 'package:bidding_bazar/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:bidding_bazar/features/auth/data/models/user_api_model.dart';

class UserMockDatasource implements IUserRemoteDataSource {
  @override
  Future<void> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String number,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      throw ServerException('Email and password are required');
    }

    if (password.length < 6) {
      throw ServerException('Password must be at least 6 characters');
    }

    // Mock successful registration
    // In a real app, this would save to a database
  }

  @override
  Future<LoginResponseModel> loginUser({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate input
    if (email.isEmpty || password.isEmpty) {
      throw ServerException('Email and password are required');
    }

    // Mock authentication logic
    if (email == 'test@example.com' && password == 'password123') {
      // Mock successful login response with a valid JWT token
      return LoginResponseModel(
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzEyMyIsImVtYWlsIjoiandvaG5AZXhhbXBsZS5jb20iLCJmaXJzdF9uYW1lIjoiSm9obiIsImxhc3RfbmFtZSI6IkRvZSIsInJvbGUiOiJ1c2VyIiwid2FsbGV0IjoxMDAuNTAsImV4cCI6MTczNTY4MDAwMH0.Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8',
        user: UserModel(
          id: 'user_123',
          email: email,
          firstName: 'John',
          lastName: 'Doe',
          number: '+1234567890',
          role: 'user',
          wallet: 100.50,
        ),
      );
    } else if (email == 'admin@example.com' && password == 'admin123') {
      // Mock admin user
      return LoginResponseModel(
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiImFkbWluXzEyMyIsImVtYWlsIjoiYWRtaW5AZXhhbXBsZS5jb20iLCJmaXJzdF9uYW1lIjoiQWRtaW4iLCJsYXN0X25hbWUiOiJVc2VyIiwicm9sZSI6ImFkbWluIiwid2FsbGV0Ijo1MDAuMDAsImV4cCI6MTczNTY4MDAwMH0.Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8Ej8',
        user: UserModel(
          id: 'admin_123',
          email: email,
          firstName: 'Admin',
          lastName: 'User',
          number: '+1234567890',
          role: 'admin',
          wallet: 500.00,
        ),
      );
    } else {
      // Mock failed login
      throw ServerException('Invalid email or password');
    }
  }
}
