import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_arch/app/core/http_client/i_http_client.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/i_space_media_datasource.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/nasa_datasource.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';

import '../../mocks/space_media_mock.dart';

class MockHttpClient extends Mock implements IHttpClient {}

main() {
  late IHttpClient client;
  late ISpaceMediaDatasource datasource;

  setUp(() {
    client = MockHttpClient();
    datasource = NasaDatasource(client);
  });

  final tDateTime = DateTime(2021, 02, 02);
  final urlExpected = 'https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2021-02-02';

  void successMock(){
    when(() => client.get(any())).thenAnswer((_) async => HttpResponse(
          data: spaceMediaMock,
          statusCode: 200,
        ));
  }
  test('Should call the get method with correct url', () async {
    // Arrange
    successMock();
    // Act
    await datasource.getSpaceMediaFromDate(tDateTime);
    // Assert
    verify(() => client.get(urlExpected)).called(1);
  });

  test('Should return a SpaceMediaModel when is successful', () async {
    // Arrange
    successMock();
    final tSpaceMediaModelExpected = SpaceMediaModel(
      title: 'A Colorful Quadrantid Meteor',
      description: "Meteors can be colorful. While the human eye usually cannot discern many colors, cameras often can. Pictured is a Quadrantids meteor captured by camera over Missouri, USA, early this month that was not only impressively bright, but colorful. The radiant grit, likely cast off by asteroid 2003 EH1, blazed a path across Earth's atmosphere...",
      mediaType: 'image',
      mediaUrl: 'https://apod.nasa.gov/apod/image/2102/MeteorStreak_Kuszaj_1080.jpg',
    );
    // Act
    final result = await datasource.getSpaceMediaFromDate(tDateTime);
    // Assert
    expect(result, tSpaceMediaModelExpected);
  });

  test('Show throw a NasaServeException when the call is unccessful', () {
    // Arrange
     when(() => client.get(any())).thenAnswer((_) async => HttpResponse(
          data: 'Something went wrong',
          statusCode: 401,
        ));
    // Act
    final result = datasource.getSpaceMediaFromDate(tDateTime);
    // Assert
    expect(result, throwsA(isA<NasaServerException>()));
  });
}
