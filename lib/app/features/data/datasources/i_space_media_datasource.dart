import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';

abstract class ISpaceMediaDatasource {
  Future<SpaceMediaModel> getSpaceMediaFromDate(DateTime date);
}
