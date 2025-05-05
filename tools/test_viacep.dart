import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(baseUrl: 'https://viacep.com.br/ws/'));
  for (var cep in ['01001000', '00000000']) {
    try {
      final res = await dio.get('$cep/json/');
      print('CEP $cep → ${res.data}');
    } on DioError catch (e) {
      print('CEP $cep → Erro HTTP ${e.response?.statusCode}');
    }
  }
}
