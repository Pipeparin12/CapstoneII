import 'package:dio/dio.dart';

class DioInstance {
  static late Dio dio;
  static String baseUrl = 'http://192.168.1.34:8080';

  static String getImage(String url) {
    if (url.startsWith("https://")) return url;
    return "$baseUrl/storage/$url";
  }

  static void init() async {
    var options = BaseOptions(
      baseUrl: baseUrl,
      contentType: "application/json",
      connectTimeout: Duration(milliseconds: 10000),
      receiveTimeout: Duration(milliseconds: 10000),
    );
    try {
      dio = Dio(options);
      print("Dio is ready");
    } catch (e) {
      print(e);
    }
  }
}
