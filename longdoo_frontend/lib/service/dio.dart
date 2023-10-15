import 'package:dio/dio.dart';

class DioInstance {
  static late Dio dio;
  static String baseUrl = 'http://10.0.2.2:8080';

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
