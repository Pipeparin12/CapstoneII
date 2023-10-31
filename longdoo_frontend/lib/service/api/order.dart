import 'package:dio/dio.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderApi {
  static Future<dynamic> getOrderById(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/order/get-order/$orderId");
    return response;
  }

  static Future<dynamic> getUnpaidOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/order/all-unpaid");
    return response;
  }

  static Future<dynamic> getProcessOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/order/all-process");
    return response;
  }

  static Future<dynamic> getShippedOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/order/all-shipped");
    return response;
  }

  static Future<dynamic> confirmShipped(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response =
        await DioInstance.dio.delete('/order/confirm-shipped/$orderId');
    return response;
  }
}
