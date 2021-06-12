import 'dart:convert';

import 'package:nasa_clean_arch/app/core/http_client/i_http_client.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/core/utils/converters/date_to_string_converter.dart';
import 'package:nasa_clean_arch/app/core/utils/keys/nasa_api_keys.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/endpoints/nasa_endpoints.dart';
import 'package:nasa_clean_arch/app/features/data/datasources/i_space_media_datasource.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';

class NasaDatasource implements ISpaceMediaDatasource {

  final IHttpClient client;
  NasaDatasource(this.client);

  @override
  Future<SpaceMediaModel> getSpaceMediaFromDate(DateTime date) async {
    final response = await client.get(NasaEndpoints.apod(NasaApiKeys.apiKey, DateToStringConverter.convert(date)));
    if(response.statusCode == 200){
      return SpaceMediaModel.fromMap(map: jsonDecode(response.data));
    }
    else{
      throw NasaServerException();
    }
  }
}
