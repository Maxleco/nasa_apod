import 'package:nasa_clean_arch/app/features/data/datasources/i_space_media_datasource.dart';
import 'package:nasa_clean_arch/app/features/domain/entities/space_media_entity.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:dartz/dartz.dart';
import 'package:nasa_clean_arch/app/features/domain/repositories/i_space_media_repository.dart';

class SpaceMediaRepository implements ISpaceMediaRepository {
  final ISpaceMediaDatasource datasource;
  SpaceMediaRepository(this.datasource);

  @override
  Future<Either<FailureNasa, SpaceMediaEntity>> getSpaceMediaFromDate(DateTime date) async {
    try {
      final result = await datasource.getSpaceMediaFromDate(date);
      return Right(result);
      
    } on NasaServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(NasaServerException());

    }
  }
}
