
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';

abstract class IUserDataSource {
  Future<void> registerUser(UserEntity entity);
  Future<String> loginUser(String email, String password);
}