import 'package:dio/dio.dart';

class DioInstance {
  static late Dio dio;
  static String baseUrl = 'http://192.168.1.53:8080';

  static void init() async {
    var options = BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    );
    try {
      dio = Dio(options);
      print("Dio is ready");
    } catch (e) {
      print(e);
    }
  }
}
