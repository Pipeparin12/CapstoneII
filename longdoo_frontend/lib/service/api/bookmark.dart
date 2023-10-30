import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class BookmarkApi {
  static Future<dynamic> getBookmark() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/bookmark/get-bookmark");
    return response;
  }

  static Future<dynamic> addToBookmark(
      String productImage, String productId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();

    try {
      var response = await DioInstance.dio
          .post("/bookmark/add-bookmark/$productId", data: {
        "productImage": productImage,
      });
      return response.data;
    } catch (e) {
      print("Error adding bookmark: $e");
      throw e;
    }
  }

  static Future<dynamic> deleteBookmark(String productId) async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response =
        await DioInstance.dio.delete('/bookmark/unbookmark/$productId');
    return response;
  }
}
