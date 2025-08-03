// lib/features/notification/presentation/bloc/notification_state.dart

part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
  });
  
  @override
  List<Object> get props => [notifications, unreadCount];
}

/// The initial state before any subscriptions or data fetching.
class NotificationInitial extends NotificationState {}

/// The state when notifications are being fetched for the first time.
class NotificationLoading extends NotificationState {}

/// The primary state representing that notifications have been loaded.
/// It contains the full list of notifications and the count of unread ones.
/// The UI will primarily be built from this state.
class NotificationLoaded extends NotificationState {
  const NotificationLoaded({
    required super.notifications,
    required super.unreadCount,
  });
}