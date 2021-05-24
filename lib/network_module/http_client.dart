import 'dart:convert';
import 'dart:io';
import 'package:workerlocatorapp/network_module/api_base.dart';
import 'package:http/http.dart' as http;
import 'package:workerlocatorapp/network_module/api_exceptions.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData(String url,
      {Map<String, String> parameters, Map<String, String> headers}) async {
    var jsonResponse;
    var uri = APIBase.baseURL +
        url +
        ((parameters != null) ? this.queryParameters(parameters) : "");
    print(uri);
    try {
      final response = await http.get(uri, headers: headers);
      // final response = await http.get(uri);

      jsonResponse = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection');
    }
    return jsonResponse;
  }

  String queryParameters(Map<String, String> parameters) {
    if (parameters != null) {
      final jsonString = Uri(queryParameters: parameters);
      return '?${jsonString.query}';
    }
    return "";
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
