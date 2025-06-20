import 'package:bidding_bazar/core/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/login_user_usecase.dart';
import '../../domain/usecase/signup_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignUpUser signUpUser;

  AuthBloc({
    required this.loginUser,
    required this.signUpUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUser(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signUpUser(
      SignUpParams(
          name: event.name, email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is CacheFailure) {
      return 'Operation Failed. Please check your details and try again.';
    }
    return 'An unexpected error occurred.';
  }
}