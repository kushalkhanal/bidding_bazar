import 'package:bidding_bazar/core/auth/auth_bloc.dart';
import 'package:bidding_bazar/core/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('More Options Screen', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () {
              // Dispatch the logout event to the central AuthBloc
              context.read<AuthBloc>().add(LoggedOut());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          )
        ],
      ),
    );
  }
}