import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/core/auth/auth_bloc.dart';
import 'package:bidding_bazar/core/auth/auth_event.dart';
import 'package:bidding_bazar/core/common/snackbar/my_snackbar.dart';
import 'package:bidding_bazar/features/auth/domain/entity/login_response_entity.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view/signup_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:bidding_bazar/view/home_view.dart'; // Make sure this view exists
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// The UseCase name was inconsistent in your file, let's standardize it
// It should match what's in your service locator: LoginUser
class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final LoginUserUsecase
  loginUserUsecase; // Changed from LoginUserUsecase to LoginUser
  final AuthBloc authBloc;

  LoginViewModel({required this.loginUserUsecase, required this.authBloc})
    : super(const LoginState.initial()) {
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<LoginButtonPressedEvent>(_onLoginButtonPressed);
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onLoginButtonPressed(
    LoginButtonPressedEvent event,
    Emitter<LoginState> emit,
  ) async {
    // 1. Emit loading state
    emit(
      state.copyWith(isLoading: true, errorMessage: null, loginResponse: null),
    );

    // 2. Call the use case
    final result = await loginUserUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    // 3. Handle the result using fold
    result.fold(
      (failure) {
        // On Failure: emit error state
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (loginResponse) {
        // On Success: emit success state with the login response
        emit(state.copyWith(isLoading: false, loginResponse: loginResponse));

        // Dispatch to AuthBloc to update global auth state
        authBloc.add(
          LoggedIn(user: loginResponse.user, token: loginResponse.token),
        );
      },
    );
  }
}
