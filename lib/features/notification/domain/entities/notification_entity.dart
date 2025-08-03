import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final String? link;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.message,
    this.link,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, message, link, isRead, createdAt];
}