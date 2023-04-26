import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl =
      'https://projectgreenhouse-6f492-default-rtdb.asia-southeast1.firebasedatabase.app';
  final Dio _dio = Dio();

  Future<dynamic> getData() async {
    try {
      final response = await _dio.get('$baseUrl/ESP32.json');
      return response.data;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<dynamic> putData(dynamic data) async {
    try {
      final response = await _dio.put('$baseUrl/ESP32.json', data: data);
      return response.data;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
