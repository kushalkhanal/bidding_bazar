import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:bidding_bazar/core/error/failure.dart';

// A generic UseCase for our business logic
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// A parameter class for when a use case doesn't need any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}