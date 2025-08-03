import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getMyNotifications();
  Future<Either<Failure, void>> markNotificationsAsRead();
}