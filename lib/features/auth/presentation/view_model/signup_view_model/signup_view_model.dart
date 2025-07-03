// lib/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart

import 'package:bidding_bazar/core/common/snackbar/my_snackbar.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/signup_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view/login_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final UserRegisterUsecase _userRegisterUsecase;

  SignupViewModel(this._userRegisterUsecase) : super(SignupState.initial()) {
    on<NavigateToLoginView>(_onNavigateToLoginView);
    on<ShowHidePassword>(_onShowHidePassword);
    on<ShowHideConfirmPassword>(_onShowHideConfirmPassword);
    on<RegisterUserEvent>(_onRegisterUser);
  }

  void _onNavigateToLoginView(
    NavigateToLoginView event,
    Emitter<SignupState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  void _onShowHidePassword(ShowHidePassword event, Emitter<SignupState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onShowHideConfirmPassword(
    ShowHideConfirmPassword event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible));
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUsecase(
      RegisterUserParams(
        username: event.username,
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        password: event.password,
      ),
    );

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: l.message,
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );
        event.onSuccess(
          
        );
      },
    );
  }
}