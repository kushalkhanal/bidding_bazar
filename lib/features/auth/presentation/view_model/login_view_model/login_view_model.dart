import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/core/common/snackbar/my_snackbar.dart';
import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view/signup_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:bidding_bazar/view/home_view.dart'; // Make sure this view exists
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final LoginUserUsecase loginUserUsecase; // Changed from LoginUserUsecase to LoginUser

  LoginViewModel({required this.loginUserUsecase}) : super(const LoginState.initial()) {
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
    emit(state.copyWith(isLoading: true, errorMessage: null, loggedInUser: null));

    // 2. Call the use case
    final result = await loginUserUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    // 3. Handle the result using fold
    result.fold(
      (failure) {
        // On Failure: emit error state
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (userEntity) {
        // On Success: emit success state with the user data
        emit(state.copyWith(
          isLoading: false,
          loggedInUser: userEntity.user,
        ));
      },
    );
  }
}