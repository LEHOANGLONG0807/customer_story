import 'package:dio/dio.dart';

class APIService {
  Dio? dio;
  final String basePath = 'http://guess.truyen.live/api';

  APIService() {
    final headers = <String, dynamic>{
      'Content-type': 'application/json',
      'accept': 'application/json',
    };
    dio = Dio(
      BaseOptions(
        baseUrl: basePath,
        connectTimeout: 15000,
        receiveTimeout: 15000,
        responseType: ResponseType.json,
        headers: headers,
      ),
    );
  }

  bool responseSuccess(var response) {
    return response.data['status'] == 200 && response.statusCode == 200;
  }

  String getError(var response) {
    return response.data['message'];
  }

  Map<String, dynamic> responseData(var response) {
    return response.data['data'];
  }
}
