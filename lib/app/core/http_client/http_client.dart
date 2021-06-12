import 'package:nasa_clean_arch/app/core/http_client/i_http_client.dart';
import 'package:http/http.dart' as http;

class HttpClient extends IHttpClient {

  final client = http.Client();

  @override
  Future<HttpResponse> get(String url) async {
    final response = await client.get(Uri.parse(url));
    return HttpResponse(data: response.body, statusCode: response.statusCode);
  }

  @override
  Future<HttpResponse> post(String url, {required Map<String, dynamic> body}) {
    throw UnimplementedError();
  }
}
