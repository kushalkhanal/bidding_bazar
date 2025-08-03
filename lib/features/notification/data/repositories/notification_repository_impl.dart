import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:bidding_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bidding_bazar/features/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getMyNotifications() async {
    try {
      final notifications = await remoteDataSource.getMyNotifications();
      return Right(notifications);
    } on DioException {
      return const Left(ServerFailure('Failed to fetch notifications.'));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationsAsRead() async {
    try {
      await remoteDataSource.markNotificationsAsRead();
      return const Right(null);
    } on DioException {
      return const Left(ServerFailure('Failed to mark notifications as read.'));
    }
  }
}