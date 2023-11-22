import 'package:dio/dio.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class UserApi {
  static Future<dynamic> signIn(String username, String password) async {
    var response = await DioInstance.dio.post("/auth/signin",
        data: {"username": username, "password": password});
    return response;
  }

  static Future<dynamic> signUp(String username, String password,
      String firstName, String lastName) async {
    var response = await DioInstance.dio.post('/auth/signup', data: {
      "username": username,
      "password": password,
      "firstName": firstName,
      "lastName": lastName
    });
    return response;
  }

  static Future<dynamic> getUsers() async {
    DioInstance.dio.options.headers["authorization"] =
        "Bearer " + SharePreference.prefs.getString("token").toString();
    final response = await DioInstance.dio.get("/account/all-user");
    return response;
  }

  static Future<Response> updateUserRoles(
      List<Map<String, dynamic>> updatedUsers) async {
    var response = await DioInstance.dio.patch('/account/update-role', data: {
      "users": updatedUsers,
    });
    return response;
  }
}
