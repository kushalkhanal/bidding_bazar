import 'package:bidding_bazar/features/auth/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final UserEntity user;
  const DashboardView({super.key, required this.user});

  bool get _isAdmin => user.role.toLowerCase() == 'admin';

  @override
  Widget build(BuildContext context) {
    // This is the content that was previously in the body of HomeView
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role-Specific Widgets
          if (_isAdmin)
            _buildAdminPanel(context) // Show this panel only for admins
          else
            _buildUserContent(context), // Show this content for users

          const Spacer(),
          Center(
            child: Text(
              _isAdmin ? 'You have administrative privileges.' : 'Happy Bidding!',
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdminPanel(BuildContext context) {
    return Card(
      elevation: 2,
      child: const ListTile(
        leading: Icon(Icons.security, color: Colors.amber),
        title: Text('Admin Controls'),
        subtitle: Text('Manage users, bids, and settings.'),
      ),
    );
  }

  Widget _buildUserContent(BuildContext context) {
    return Card(
      elevation: 2,
      child: const ListTile(
        leading: Icon(Icons.gavel, color: Colors.green),
        title: Text('My Bids'),
        subtitle: Text('View your active and past bids.'),
      ),
    );
  }
}