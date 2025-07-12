import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class FakeLoginUserParams extends Fake implements LoginUserParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginUserParams());
  });

  late LoginViewModel loginViewModel;
  late MockUserLoginUsecase mockUserLoginUsecase;

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(mockUserLoginUsecase);
  });

  test('initial state is LoginState.initial()', () {
    expect(loginViewModel.state.isLoading, isFalse);
    expect(loginViewModel.state.isSuccess, isFalse);
    expect(loginViewModel.state.isPasswordVisible, isFalse);
  });

  group('TogglePasswordVisibility', () {
    blocTest<LoginViewModel, LoginState>(
      'should emit state with isPasswordVisible as true when it is initially false',
      build: () => loginViewModel,
      act: (bloc) => bloc.add(TogglePasswordVisibility()),
      expect: () => [
        LoginState(isLoading: false, isSuccess: false, isPasswordVisible: true),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'should emit state with isPasswordVisible as false when it is initially true',
      seed: () => LoginState(isLoading: false, isSuccess: false, isPasswordVisible: true),
      build: () => loginViewModel,
      act: (bloc) => bloc.add(TogglePasswordVisibility()),
      expect: () => [
        LoginState(isLoading: false, isSuccess: false, isPasswordVisible: false),
      ],
    );
  });

}

class MockBuildContext extends Mock implements BuildContext {}