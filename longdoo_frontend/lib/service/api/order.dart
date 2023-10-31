import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class OrderApi {
  static Future<dynamic> getOrderById(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/order/get-order/$orderId");
    return response;
  }

  static Future<dynamic> getOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/order/all");
    return response;
  }
}
