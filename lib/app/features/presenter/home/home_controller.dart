import 'package:mobx/mobx.dart';
import 'package:nasa_clean_arch/app/features/domain/usecases/get_space_media_from_date_usecase.dart';
part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final GetSpaceMediaFromDateUsecase usecase;
  _HomeControllerBase(this.usecase);
  
}