
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:bidding_bazar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bidding_bazar/features/auth/presentation/screens/login_screen.dart';
import 'package:bidding_bazar/features/auth/presentation/screens/splash_screen.dart';
import 'package:bidding_bazar/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:bidding_bazar/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // This is correct because AuthBloc needs to be started immediately.
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(AppStarted()),
        ),

        // --- FIX: Use the GetIt instance directly ---
        // Instead of creating a new NotificationBloc, we tell the provider
        // to use the one that GetIt already knows how to create.
        BlocProvider<NotificationBloc>(
          create: (context) => sl<NotificationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Bidding Bazar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return const SplashScreen();
            }
            if (state is Authenticated) {
              return const MainScreen();
            }
            if (state is Unauthenticated || state is AuthError || state is RegistrationSuccess) {
              return const LoginScreen();
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}