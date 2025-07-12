import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/signup_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}
class MockBuildContext extends Mock implements BuildContext {}
class FakeRegisterUserParams extends Fake implements RegisterUserParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRegisterUserParams());
  });



  late SignupViewModel signupViewModel;
  late MockUserRegisterUsecase mockUserRegisterUsecase;

  setUp(() {
    mockUserRegisterUsecase = MockUserRegisterUsecase();
    signupViewModel = SignupViewModel(mockUserRegisterUsecase);
  });

  test('initial state is SignupState.initial()', () {
    expect(signupViewModel.state, equals(SignupState.initial()));
  });

  group('Password Visibility', () {
    blocTest<SignupViewModel, SignupState>(
      'should toggle isPasswordVisible when ShowHidePassword is added',
      build: () => signupViewModel,
      act: (bloc) => bloc.add(ShowHidePassword(context: MockBuildContext(), isVisible: true)),
      expect: () => [
        isA<SignupState>().having((s) => s.isPasswordVisible, 'isPasswordVisible', true),
      ],
    );

    blocTest<SignupViewModel, SignupState>(
      'should toggle isConfirmPasswordVisible when ShowHideConfirmPassword is added',
      build: () => signupViewModel,
      act: (bloc) => bloc.add(ShowHideConfirmPassword(context: MockBuildContext(), isVisible: true)),
      expect: () => [
        isA<SignupState>().having((s) => s.isConfirmPasswordVisible, 'isConfirmPasswordVisible', true),
      ],
    );
  });

  

}

