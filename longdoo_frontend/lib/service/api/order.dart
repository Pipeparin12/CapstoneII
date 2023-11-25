import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class OrderApi {
  static Future<dynamic> getOrderById(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/get-order/$orderId");
    return response;
  }

  static Future<dynamic> getUnpaidOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/all-unpaid");
    return response;
  }

  static Future<dynamic> getProcessOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/all-process");
    return response;
  }

  static Future<dynamic> getWaitingOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/waiting");
    return response;
  }

  static Future<dynamic> getPackingOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/packing");
    return response;
  }

  static Future<dynamic> getOnTheWayOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/on-the-way");
    return response;
  }

  static Future<dynamic> getShippedOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/all-shipped");
    return response;
  }

  static Future<dynamic> getCompleteOrder() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/order/complete");
    return response;
  }

  static Future<dynamic> confirmShipped(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response =
        await DioInstance.dio.patch('/order/confirm-shipped/$orderId');
    return response;
  }

  static Future<dynamic> updateStatus(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response =
        await DioInstance.dio.patch('/order/update-status/$orderId');
    return response;
  }

  static Future<dynamic> updateTracking(
      String orderId, String description) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.patch(
      '/order/update-tracking/$orderId',
      data: {'description': description},
    );

    return response;
  }

  static Future<dynamic> updateShipment(String orderId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response =
        await DioInstance.dio.patch('/order/update-shipment/$orderId');
    return response;
  }
}
