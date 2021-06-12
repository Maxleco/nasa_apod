import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'errors/failure_nasa.dart';

abstract class Usecase<Output, Input> {
  Future<Either<FailureNasa, Output>> call(Input params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}