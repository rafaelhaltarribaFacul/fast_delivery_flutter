import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://viacep.com.br/ws/',
                connectTimeout: 5000,
                receiveTimeout: 3000,
              ),
            );

  Future<Response> getCep(String cep) async {
    return _dio.get('$cep/json/');
  }
}
