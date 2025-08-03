
import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:bidding_bazar/features/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyNotifications implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;
  GetMyNotifications(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) async {
    return await repository.getMyNotifications();
  }
}