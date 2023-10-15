import 'package:longdoo_app/service/dio.dart';

class UserApi {
  static Future<dynamic> signIn(String username, String password) async {
    var response = await DioInstance.dio
        .post("/auth/signin", data: {"username": username, "password": password});
    return response;
  }

  static Future<dynamic> signUp(String username, String password, String firstName, String lastName) async {
    var response = await DioInstance.dio
        .post('/auth/signup', data: {"username": username, "password": password, "firstName": firstName, "lastName": lastName});
  }
}