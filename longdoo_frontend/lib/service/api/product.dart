import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class ProductApi {
  static Future<dynamic> getMen() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get('/product/category/Men');
    return response;
  }

  static Future<dynamic> getWomen() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get('/product/category/Women');
    return response;
  }

  static Future<dynamic> getKids() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get('/product/category/Kids');
    return response;
  }

  static Future<dynamic> getUnisex() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get('/product/category/Unisex');
    return response;
  }

  static Future<dynamic> getBook(String bookId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/book/$bookId");
    return response;
  }

  static Future<dynamic> getSale() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get('/product/category/Sale');
    return response;
  }
}
