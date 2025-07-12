import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late UserLoginUsecase usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = UserLoginUsecase(
      repository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  const tEmail = 'kushal@gmail.com';
  const tPassword = 'kushal123';
  const tLoginParams = LoginUserParams(email: tEmail, password: tPassword);
  const tToken = 'a-very-secret-auth-token';
  const tFailure = RemoteDatabaseFailure(message: 'Invalid Credentials');

  test(
    'should call repository, save token to shared prefs, and return token on success',
    () async {
      when(
        () => mockUserRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Right(tToken));

      when(() => mockTokenSharedPrefs.saveToken(any())).thenAnswer(
        (_) async => const Right(true),
      ); // Assuming it returns Right(true) on success

      final result = await usecase(tLoginParams);

      expect(result, const Right(tToken));

      verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);

      verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);

      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    },
  );

  test(
    'should return a Failure when the repository fails and NOT save the token',
    () async {
      when(
        () => mockUserRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tLoginParams);

      expect(result, const Left(tFailure));

      verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);

      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));

      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    },
  );
}
