import 'package:flutter/material.dart';
import 'package:bidding_bazar/core/network/socket_service.dart';

class NotificationService {
  static NotificationService? _instance;
  final SocketService _socketService = SocketService.instance;

  NotificationService._();

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  void initialize(BuildContext context) {
    _socketService.notifications.listen((notification) {
      _showNotification(context, notification);
    });
  }

  void _showNotification(BuildContext context, Map<String, dynamic> notification) {
    final message = notification['message'] ?? 'New notification';
    final type = notification['type'] ?? 'info';

    Color backgroundColor;
    IconData icon;

    switch (type) {
      case 'bid':
        backgroundColor = Colors.green;
        icon = Icons.gavel;
        break;
      case 'auction_ended':
        backgroundColor = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'outbid':
        backgroundColor = Colors.red;
        icon = Icons.trending_down;
        break;
      default:
        backgroundColor = Colors.blue;
        icon = Icons.notifications;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showCustomNotification(BuildContext context, String message, {Color? backgroundColor, IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.blue,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 