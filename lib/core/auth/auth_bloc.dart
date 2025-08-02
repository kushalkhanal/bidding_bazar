import 'package:bidding_bazar/app/shared_pref/token_shared_preference.dart';
import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/core/auth/auth_event.dart';
import 'package:bidding_bazar/core/auth/auth_state.dart';
import 'package:bidding_bazar/core/auth/auth_utils.dart';
import 'package:bidding_bazar/features/auth/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenSharedPrefs _tokenSharedPrefs;
  final IUserRepository _userRepository;

  AuthBloc({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs,
      _userRepository = serviceLocator<IUserRepository>(),
      super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      // Check if token exists
      final hasTokenResult = await _tokenSharedPrefs.hasToken();

      hasTokenResult.fold(
        (failure) {
          // If we fail to check token, treat as unauthenticated
          emit(Unauthenticated());
        },
        (hasToken) async {
          if (hasToken) {
            // Token exists, get it and validate
            final tokenResult = await _tokenSharedPrefs.getToken();

            tokenResult.fold(
              (failure) {
                // If we fail to get the token, clear it and treat as unauthenticated
                _tokenSharedPrefs.clearToken();
                emit(Unauthenticated());
              },
              (token) async {
                if (token != null && token.isNotEmpty) {
                  // Validate the token format and expiration
                  if (AuthUtils.isValidJWTFormat(token) &&
                      !AuthUtils.isTokenExpired(token)) {
                    // Token is valid, fetch complete user data from API
                    await _fetchUserDataAndEmit(token);
                  } else {
                    // Token is invalid or expired, clear it
                    await _tokenSharedPrefs.clearToken();
                    emit(Unauthenticated());
                  }
                } else {
                  // Token is null or empty, clear it and treat as unauthenticated
                  await _tokenSharedPrefs.clearToken();
                  emit(Unauthenticated());
                }
              },
            );
          } else {
            // No token exists
            emit(Unauthenticated());
          }
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      emit(Unauthenticated());
    }
  }

  Future<void> _fetchUserDataAndEmit(String token) async {
    try {
      // Fetch complete user data from API
      final userResult = await _userRepository.getMe();

      userResult.fold(
        (failure) {
          // If we fail to get user data, clear token and emit unauthenticated
          _tokenSharedPrefs.clearToken();
          emit(Unauthenticated());
        },
        (user) {
          // User data fetched successfully
          emit(Authenticated(user: user));
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      await _tokenSharedPrefs.clearToken();
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      // Validate the token before saving
      if (!AuthUtils.isValidJWTFormat(event.token)) {
        emit(Unauthenticated());
        return;
      }

      // Save the token
      final saveResult = await _tokenSharedPrefs.saveToken(event.token);

      saveResult.fold(
        (failure) {
          // If we fail to save the token, don't authenticate
          emit(Unauthenticated());
        },
        (_) async {
          // Token saved successfully, emit authenticated state
          emit(Authenticated(user: event.user));
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    try {
      // Clear the token and user data
      final clearResult = await _tokenSharedPrefs.clearToken();

      clearResult.fold(
        (failure) {
          // Even if clearing fails, we should still emit unauthenticated
          // The token might be invalid anyway
          emit(Unauthenticated());
        },
        (_) {
          // Token cleared successfully
          emit(Unauthenticated());
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      emit(Unauthenticated());
    }
  }
}
