// lib/features/notification/presentation/bloc/notification_bloc.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:bidding_bazar/core/api/socket_client.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/notification/data/models/notification_model.dart';
import 'package:bidding_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bidding_bazar/features/notification/domain/usecases/get_my_notifications.dart';
import 'package:bidding_bazar/features/notification/domain/usecases/mark_notifications_as_read.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetMyNotifications getMyNotifications;
  final MarkNotificationsAsRead markNotificationsAsRead;
  final SocketClient socketClient;
  final AudioPlayer _audioPlayer;

  NotificationBloc({
    required this.getMyNotifications,
    required this.markNotificationsAsRead,
    required this.socketClient,
  }) : 
    _audioPlayer = AudioPlayer(),
    super(NotificationInitial()) {
    on<SubscribeToNotifications>(_onSubscribe);
    on<FetchNotifications>(_onFetchNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<_NewNotificationReceived>(_onNewNotificationReceived);
  }

  void _onSubscribe(SubscribeToNotifications event, Emitter<NotificationState> emit) {
    socketClient.connect();
    socketClient.joinUserRoom(event.userId); 
    
    socketClient.listenForNewNotification((data) {
      if (data is Map<String, dynamic>) {
        final notification = NotificationModel.fromJson(data);
        add(_NewNotificationReceived(notification));
        _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      }
    });
    // After subscribing, fetch any existing notifications.
    add(FetchNotifications());
  }

  void _onFetchNotifications(FetchNotifications event, Emitter<NotificationState> emit) async {
    // Only show a full-screen loader on the very first load.
    if (state is NotificationInitial) {
        emit(NotificationLoading());
    }

    final result = await getMyNotifications(NoParams());
    result.fold(
      (failure) => emit(const NotificationLoaded(notifications: [], unreadCount: 0)),
      (notifications) {
        final unread = notifications.where((n) => !n.isRead).length;
        emit(NotificationLoaded(notifications: notifications, unreadCount: unread));
      },
    );
  }

  void _onMarkAsRead(MarkAsRead event, Emitter<NotificationState> emit) async {
    // Prevent unnecessary API calls if there's nothing to mark as read.
    if (state.unreadCount == 0) return;

    // Immediately update the UI for a snappy user experience (Optimistic Update).
    final readNotifications = state.notifications.map((n) {
      return NotificationModel(id: n.id, message: n.message, isRead: true, createdAt: n.createdAt, link: n.link);
    }).toList();
    emit(NotificationLoaded(notifications: readNotifications, unreadCount: 0));

    // Then, call the API in the background to update the database.
    await markNotificationsAsRead(NoParams());
  }

  void _onNewNotificationReceived(_NewNotificationReceived event, Emitter<NotificationState> emit) {
    // Add the new notification to the top of the existing list.
    final updatedList = [event.notification, ...state.notifications];
    // Increment the unread count.
    emit(NotificationLoaded(notifications: updatedList, unreadCount: state.unreadCount + 1));
  }

  @override
  Future<void> close() {
    // Dispose of the audio player when the BLoC is closed to free up resources.
    _audioPlayer.dispose();
    return super.close();
  }
}