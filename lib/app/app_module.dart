import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_clean_arch/app/core/http_client/http_client.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/nasa_datasource.dart';
import 'package:nasa_clean_arch/app/features/data/repositories/space_media_repository.dart';
import 'package:nasa_clean_arch/app/features/domain/usecases/get_space_media_from_date_usecase.dart';
import 'package:nasa_clean_arch/app/features/presenter/home/home_controller.dart';
import 'features/presenter/home/home_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HttpClient()),
    Bind.lazySingleton((i) => NasaDatasource(i<HttpClient>())),
    Bind.lazySingleton((i) => SpaceMediaRepository(i<NasaDatasource>())),
    Bind.lazySingleton((i) => GetSpaceMediaFromDateUsecase(i<SpaceMediaRepository>())),
    Bind.lazySingleton((i) => HomeController(i<GetSpaceMediaFromDateUsecase>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
  ];

}