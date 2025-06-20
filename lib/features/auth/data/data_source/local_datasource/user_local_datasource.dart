
import 'package:bidding_bazar/core/network/hive_service.dart';
import 'package:bidding_bazar/features/auth/data/data_source/user_data_source.dart';
import 'package:bidding_bazar/features/auth/data/models/user_hive_model.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final loginUser = await _hiveService.loginUser(email, password);
      if (loginUser != null && loginUser.password == password) {
        return "Login Successful";
      } else {
        return "Invalid Credentials";
      }
    } catch (e) {
      throw Exception("Login Failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(entity);
      await _hiveService.registerUser(userHiveModel);
    } catch (e) {
      throw Exception("Registration Failed: $e");
    }
  }
}