import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/signup_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeUserEntity extends Fake implements UserEntity {}

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  late MockUserRepository mockUserRepository;
  late UserRegisterUsecase usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UserRegisterUsecase(repository: mockUserRepository);
  });

  const tRegisterParams = RegisterUserParams(
    username: 'kushal',
    email: 'kushal@gmail.com',
    firstName: 'Kushal',
    lastName: 'Khanal',
    password: 'password123',
  );

  const tUserEntity = UserEntity(
    username: 'kushal',
    email: 'kushal@gmail.com',
    firstName: 'Kushal',
    lastName: 'Khanal',
    password: 'password123',
  );

  const tFailure = RemoteDatabaseFailure(message: 'Username already exists');


  test(
    'should create a UserEntity and call the repository to register the user',
    () async {
      when(() => mockUserRepository.registerUser(any()))
          .thenAnswer((_) async => const Right(null));

      // ACT
      final result = await usecase(tRegisterParams);

      // ASSERT
      expect(result, const Right(null));
      verify(() => mockUserRepository.registerUser(tUserEntity)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    },
  );


  // --- TEST CASE 2: FAILURE (No changes needed here) ---
  test(
    'should return a Failure when the repository call is unsuccessful',
    () async {
      // ARRANGE
      when(() => mockUserRepository.registerUser(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // ACT
      final result = await usecase(tRegisterParams);

      // ASSERT
      expect(result, const Left(tFailure));
      verify(() => mockUserRepository.registerUser(tUserEntity)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}