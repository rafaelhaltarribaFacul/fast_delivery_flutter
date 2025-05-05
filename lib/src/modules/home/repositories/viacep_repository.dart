import 'package:dio/dio.dart';
import 'package:fast_delivery/src/shared/http/dio_client.dart';

class ViacepRepository {
  final DioClient _client;

  ViacepRepository({DioClient? client}) : _client = client ?? DioClient();

  Future<Map<String, dynamic>> fetchCep(String cep) async {
    final Response response = await _client.getCep(cep);
    return response.data as Map<String, dynamic>;
  }
}
