import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart' as MOD;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_arch/app/app_module.dart';
import 'package:nasa_clean_arch/app/core/http_client/http_client.dart';
import 'package:nasa_clean_arch/app/core/http_client/i_http_client.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/nasa_datasource.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';
import 'package:nasa_clean_arch/app/features/data/repositories/space_media_repository.dart';
import 'package:nasa_clean_arch/app/features/domain/usecases/get_space_media_from_date_usecase.dart';

import 'features/mocks/space_media_mock.dart';

class MockHttpClient extends Mock implements HttpClient {}

main() {
  final client = MockHttpClient();

  setUp(() {
    final AppModule module = AppModule();
    module.changeBinds([
      MOD.Bind.lazySingleton((i) => client),
      MOD.Bind.lazySingleton((i) => NasaDatasource(i<MockHttpClient>())),
      MOD.Bind.lazySingleton((i) => SpaceMediaRepository(i<NasaDatasource>())),
      MOD.Bind.lazySingleton((i) => GetSpaceMediaFromDateUsecase(i<SpaceMediaRepository>())),
    ]);
    MOD.Modular.init(module);
  });

  // RIGHT - Date
  final tDate = DateTime(2021, 02, 02);

  test('Deve recuperar o usecase GetSpaceMediaFromDateUsecase sem erro', () {
    // Act
    final usecase = MOD.Modular.get<GetSpaceMediaFromDateUsecase>();
    // Assert
    expect(usecase, isA<GetSpaceMediaFromDateUsecase>());
  });

  test('Deve trazer uma instância de SpaceMediaEntity', () async {
    // Arrange
    when(() => client.get(any())).thenAnswer((_) async => HttpResponse(
          data: spaceMediaMock,
          statusCode: 200,
        ));
    // Act
    final usecase = MOD.Modular.get<GetSpaceMediaFromDateUsecase>();
    final result = await usecase.call(tDate);
    // Assert
    expect(result.fold(id, id), isA<SpaceMediaModel>());
    verify(() => client.get(any())).called(1);
  });
}
