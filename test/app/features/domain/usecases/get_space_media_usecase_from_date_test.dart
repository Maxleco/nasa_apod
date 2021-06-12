import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/domain/entities/space_media_entity.dart';
import 'package:nasa_clean_arch/app/features/domain/repositories/i_space_media_repository.dart';
import 'package:nasa_clean_arch/app/features/domain/usecases/get_space_media_from_date_usecase.dart';

class MockSpaceMediaRepository extends Mock implements ISpaceMediaRepository {}

void main() {
  late ISpaceMediaRepository repository;
  late GetSpaceMediaFromDateUsecase usecase;

  setUp(() {
    repository = MockSpaceMediaRepository();
    usecase = GetSpaceMediaFromDateUsecase(repository);
  });

  final tSpaceMedia = SpaceMediaEntity(
    description: 'Description',
    title: 'Title',
    mediaType: 'image',
    mediaUrl: 'https://apod.nasa.gov/apod/image/...',
  );

  // RIGHT - Date
  final tDate = DateTime(2021, 02, 02);
  // LEFT  - Failure (Exception)
  final failure = NasaServerFailure();

  test('Should get space media entity for a given date from the repository',
      () async {
    when(() => repository.getSpaceMediaFromDate(any())).thenAnswer(
        (_) async => Right<FailureNasa, SpaceMediaEntity>(tSpaceMedia));

    final result = await usecase(tDate);
    expect(result, Right(tSpaceMedia));
    // confirming that the repository was called with the correct arguments.
    verify(() => repository.getSpaceMediaFromDate(tDate)).called(1);
  });

  test('Should return a NasaServerFailure when don\'t succeed', () async {
    when(() => repository.getSpaceMediaFromDate(any()))
        .thenAnswer((_) async => Left<FailureNasa, SpaceMediaEntity>(failure));

    final result = await usecase(tDate);
    expect(result, Left(failure));
    // confirming that the repository was called with the correct arguments.
    verify(() => repository.getSpaceMediaFromDate(tDate)).called(1);
  });
}

