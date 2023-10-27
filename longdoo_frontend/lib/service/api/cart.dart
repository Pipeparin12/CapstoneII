import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class CartApi {
  static Future<dynamic> addToCart(
      int quantity, String productId, String size, String productImage) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();

    try {
      var response =
          await DioInstance.dio.post("/cart/add-cart/$productId", data: {
        "quantity": quantity,
        "size": size,
        "productImage": productImage,
      });
      // Return the response from the API call
      return response.data;
    } catch (e) {
      // Handle any errors here, you might want to return an error response or throw an exception
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
}
