// lib/features/notification/presentation/bloc/notification_event.dart

part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

/// Dispatched once when the user logs in to subscribe to their notification channel.
class SubscribeToNotifications extends NotificationEvent {
  final String userId;
  const SubscribeToNotifications(this.userId);

  @override
  List<Object> get props => [userId];
}

/// Dispatched to fetch the initial list of notifications from the server.
class FetchNotifications extends NotificationEvent {}

/// Dispatched when the user enters the notification screen to mark all as read.
class MarkAsRead extends NotificationEvent {}

/// A private event that is only added from within the BLoC when a new
/// notification is received from the Socket.IO stream.
class _NewNotificationReceived extends NotificationEvent {
  final NotificationEntity notification;
  const _NewNotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];
}