import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class CartApi {
  static Future<dynamic> addToCart(
      int quantity, String productId, String size, String productImage) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";

    try {
      var response =
          await DioInstance.dio.get("/cart/check-product/$productId");

      if (response.data['found']) {
        int existingQuantity = response.data['quantity'];
        quantity += existingQuantity;
        await DioInstance.dio.put("/cart/update-cart/$productId", data: {
          "quantity": quantity,
          "size": size,
          "productImage": productImage,
        });
      } else {
        await DioInstance.dio.post("/cart/add-cart/$productId", data: {
          "quantity": quantity,
          "size": size,
          "productImage": productImage,
        });
      }
      return "Product added to cart.";
    } catch (e) {
      print("Error adding to cart: $e");
      rethrow;
    }
  }

  static Future<void> updateCartItemQuantity(
      String productId, String size, int quantity, String productImage) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";

    try {
      await DioInstance.dio.put("/cart/update-cart/$productId", data: {
        "quantity": quantity,
        "size": size,
        "productImage": productImage,
      });
    } catch (e) {
      print("Error updating cart item quantity: $e");
      rethrow;
    }
  }

  static Future<dynamic> getCart() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    final response = await DioInstance.dio.get("/cart/get-cart");
    return response;
  }

  static Future<dynamic> checkout() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer ${SharePreference.prefs.getString("token")}";
    var response = await DioInstance.dio.post("/cart/checkout");
  }
}
