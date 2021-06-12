import 'package:dartz/dartz.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/domain/entities/space_media_entity.dart';

abstract class ISpaceMediaRepository {
  Future<Either<FailureNasa, SpaceMediaEntity>> getSpaceMediaFromDate(DateTime date);
}