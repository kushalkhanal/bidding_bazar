import 'package:bidding_bazar/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mark notifications as read when the user enters the screen
    context.read<NotificationBloc>().add(MarkAsRead());

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.notifications.isEmpty) {
            return const Center(child: Text('You have no notifications.'));
          }
          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return ListTile(
                leading: Icon(
                  notification.isRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread,
                  color: notification.isRead ? Colors.grey : Theme.of(context).colorScheme.primary,
                ),
                title: Text(notification.message),
                subtitle: Text(DateFormat.yMd().add_jm().format(notification.createdAt.toLocal())),
                onTap: () {
                  // TODO: Handle navigation if notification.link is not null
                },
              );
            },
          );
        },
      ),
    );
  }
}