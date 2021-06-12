import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:dartz/dartz.dart';
import 'package:nasa_clean_arch/app/core/usecase/usecase.dart';
import 'package:nasa_clean_arch/app/features/domain/entities/space_media_entity.dart';
import 'package:nasa_clean_arch/app/features/domain/repositories/i_space_media_repository.dart';

class GetSpaceMediaFromDateUsecase implements Usecase<SpaceMediaEntity, DateTime> {
  final ISpaceMediaRepository repository;
  GetSpaceMediaFromDateUsecase(this.repository);

  @override
  Future<Either<FailureNasa, SpaceMediaEntity>> call(DateTime date) async {
    return await repository.getSpaceMediaFromDate(date);
  }
  
}
