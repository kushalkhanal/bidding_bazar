import 'package:bidding_bazar/core/common/snackbar/my_snackbar.dart';
import 'package:bidding_bazar/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:bidding_bazar/view/home_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _loginUsecase;
  LoginViewModel(this._loginUsecase) : super(LoginState.initial()) {
    on<NavigateToSignupView>(_onNavigateToSignupView);
    on<NavigateToHomeView>(_onNavigateToHomeView);
    on<ShowHidePassword>(_onShowHidePassword);
    on<LoginIntoSystemEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToSignupView(
    NavigateToSignupView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: SignupView(),
              ),
        ),
      );
    }
  }


  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
          /// single bloc huna sakcha
              (context) => BlocProvider.value(
                value: serviceLocator<HomeViewModel>(),
                child: HomeView(),
              ),
        ),
      );
    }
  }

  void _onShowHidePassword(ShowHidePassword event, Emitter<LoginState> emit) {
    emit(state.copyWith(isPasswordVisible: event.isVisible));
  }

  void _onLoginWithEmailAndPassword(
    LoginIntoSystemEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _loginUsecase(
      LoginUserParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(
          NavigateToHomeView(context: event.context, destination: HomeView()),
        );
      },
    );
  }
}