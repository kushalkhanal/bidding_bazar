import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../features/auth/data/data_source/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;
  final Uuid uuid;
  AuthLocalDataSourceImpl({required this.userBox, required this.uuid});

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final existingUser = userBox.values.cast<UserModel?>().firstWhere(
          (user) => user?.email.toLowerCase() == email.toLowerCase(),
          orElse: () => null,
        );
    if (existingUser != null) {
      throw Exception('User with this email already exists.');
    }
    final newUser = UserModel(
      id: uuid.v4(),
      name: name,
      email: email,
      password: password,
    );
    await userBox.put(newUser.id, newUser);
    return newUser;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final user = userBox.values.cast<UserModel?>().firstWhere(
          (user) => user?.email.toLowerCase() == email.toLowerCase(),
          orElse: () => null,
        );
    if (user != null && user.password == password) {
      return user;
    } else {
      throw Exception('Invalid email or password.');
    }
  }
}