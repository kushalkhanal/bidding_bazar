
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/check_auth_status.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/login_user.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/logout_user.dart';
import 'package:bidding_bazar/features/auth/domain/usecases/register_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final CheckAuthStatus checkAuthStatus;
  final LogoutUser logoutUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.checkAuthStatus,
    required this.logoutUser,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final failureOrUser = await checkAuthStatus(NoParams());
    emit(failureOrUser.fold(
      (failure) => Unauthenticated(),
      (user) => Authenticated(user),
    ));
  }

  void _onLoginButtonPressed(LoginButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrUser = await loginUser(LoginParams(email: event.email, password: event.password));
    emit(failureOrUser.fold(
      (failure) => AuthError("failure.message"),
      (user) => Authenticated(user),
    ));
  }

  void _onRegisterButtonPressed(RegisterButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrSuccess = await registerUser(RegisterParams(
      email: event.email,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
      number: event.number,
    ));
    emit(failureOrSuccess.fold(
      (failure) => AuthError("failure.message"),
      (_) => RegistrationSuccess(),
    ));
  }

  void _onLogoutButtonPressed(LogoutButtonPressed event, Emitter<AuthState> emit) async {
    final failureOrSuccess = await logoutUser(NoParams());
    emit(failureOrSuccess.fold(
      (failure) => AuthError("failure.message"),
      (_) => Unauthenticated(),
    ));
  }
}