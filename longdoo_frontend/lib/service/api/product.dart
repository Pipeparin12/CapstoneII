import 'package:flutter/foundation.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class ProductApi {
  static Future<dynamic> getProduct(String category) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get('/product/category/$category');
    return response;
  }

  static Future<dynamic> getBySize(String category) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response =
        await DioInstance.dio.get('/product/yourProduct/$category');

    return response;
  }

  static Future<dynamic> getDetail(String id) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/product/$id");
    return response;
  }

  static Future<dynamic> updateQuantity(String id, int quantity) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.patch("/product/update-quantity");
    return response;
  }
}
