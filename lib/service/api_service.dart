import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio dio = Dio();
  final String _baseUrl = dotenv.get('API_URL');

  ApiService() {
    dio.options.baseUrl = _baseUrl;
    dio.options.headers['content-type'] = 'application/json';
    dio.options.headers['accept'] = 'application/json';
  }
}
