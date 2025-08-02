import 'package:bidding_bazar/app/service_locator/service_locator.dart';
import 'package:bidding_bazar/core/auth/auth_bloc.dart';
import 'package:bidding_bazar/core/auth/auth_event.dart';
import 'package:bidding_bazar/core/auth/auth_state.dart';
import 'package:bidding_bazar/features/auth/presentation/view/login_view.dart';
import 'package:bidding_bazar/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:bidding_bazar/features/splash/presentation/view/splash_view.dart';
import 'package:bidding_bazar/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Handle any side effects here, like showing snackbars
          if (state is Unauthenticated) {
            // User logged out or token expired
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You have been logged out'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              // App is starting, trigger auth check
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AuthBloc>().add(AppStarted());
              });
              return BlocProvider.value(
                value: serviceLocator<SplashViewModel>(),
                child: const SplashView(),
              );
            } else if (state is Authenticated) {
              // User is authenticated, show main app
              return _buildAuthenticatedScreen(context, state.user);
            } else if (state is Unauthenticated) {
              // User is not authenticated, show login with LoginViewModel provider
              return BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              );
            } else {
              // Fallback to splash
              return BlocProvider.value(
                value: serviceLocator<SplashViewModel>(),
                child: const SplashView(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAuthenticatedScreen(BuildContext context, user) {
    // Replace this with your main app screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bidding Bazar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LoggedOut());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user.firstName}!'),
            const SizedBox(height: 20),
            Text('Email: ${user.email}'),
            const SizedBox(height: 20),
            Text('Role: ${user.role}'),
            const SizedBox(height: 20),
            Text('Wallet: \$${user.wallet}'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LoggedOut());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
