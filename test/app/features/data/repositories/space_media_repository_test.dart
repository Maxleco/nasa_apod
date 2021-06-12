import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/i_space_media_datasource.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';
import 'package:nasa_clean_arch/app/features/data/repositories/space_media_repository.dart';
import 'package:dartz/dartz.dart';

class MockSearchMediaDatasource extends Mock implements ISpaceMediaDatasource {}

main() {

  late ISpaceMediaDatasource datasource;
  late SpaceMediaRepository repository;
  
  setUp((){
    datasource = MockSearchMediaDatasource(); 
    repository = SpaceMediaRepository(datasource);
  });

  final tSpaceMediaModel = SpaceMediaModel(
    description: 'Description',
    title: 'Title',
    mediaType: 'image',
    mediaUrl: 'https://apod.nasa.gov/apod/image/...',
  );

  // RIGHT - Date
  final tDate = DateTime(2021, 02, 02);
  // LEFT  - Failure (Exception)
  final failure = NasaServerFailure();

  test('Should return space media model when calls the Datasource', () async {
    // Arrange
    when(() => datasource.getSpaceMediaFromDate(any())).thenAnswer(
        (_) async => tSpaceMediaModel);
    //Act
    final result = await repository.getSpaceMediaFromDate(tDate);
    //Assert
    expect(result, Right(tSpaceMediaModel));
    verify(() => datasource.getSpaceMediaFromDate(tDate)).called(1);
  });

  test('Should return a Server Failure when the calls to Datasource is unsucessful', () async {
    // Arrange
    when(() => datasource.getSpaceMediaFromDate(any())).thenThrow(failure);
    //Act
    final result = await repository.getSpaceMediaFromDate(tDate);
    //Assert
    expect(result, Left(failure));
    verify(() => datasource.getSpaceMediaFromDate(tDate)).called(1);
  });
}
