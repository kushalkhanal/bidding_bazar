import 'package:bidding_bazar/core/error/failure.dart';
import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/features/notification/domain/repository/notification_repository.dart';
import 'package:dartz/dartz.dart';

class MarkNotificationsAsRead implements UseCase<void, NoParams> {
  final NotificationRepository repository;
  MarkNotificationsAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.markNotificationsAsRead();
  }
}