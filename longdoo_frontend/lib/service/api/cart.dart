import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class CartApi {
  static Future<dynamic> addToCart(
      int quantity, String productId, String size, String productImage) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();

    try {
      // Check if the product already exists in the cart
      var response =
          await DioInstance.dio.get("/cart/check-product/$productId");

      if (response.data['found']) {
        // Product already exists in the cart, so update the quantity
        int existingQuantity = response.data['quantity'];
        quantity += existingQuantity;
        await DioInstance.dio.put("/cart/update-cart/$productId", data: {
          "quantity": quantity,
          "size": size,
          "productImage": productImage,
        });
      } else {
        // Product is not in the cart, so create a new cart entry
        await DioInstance.dio.post("/cart/add-cart/$productId", data: {
          "quantity": quantity,
          "size": size,
          "productImage": productImage,
        });
      }

      // Return a success message or updated cart data
      return "Product added to cart.";
    } catch (e) {
      // Handle any errors here
      print("Error adding to cart: $e");
      throw e;
    }
  }

  static Future<dynamic> getCart() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/cart/get-cart");
    return response;
  }

  static Future<dynamic> checkout() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    var response = await DioInstance.dio.post("/cart/checkout");
  }
}
