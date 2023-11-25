import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/model/user.dart';
import 'package:longdoo_frontend/screen/admin/home_admin.dart';
import 'package:longdoo_frontend/screen/signUpScreen.dart';
import 'package:longdoo_frontend/service/api/user.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class SignInPage extends StatefulWidget {
  static String routeName = "/sign_in";
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool? isLoading = false;
  bool? remember = false;

  void signInHandler() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        var result = await UserApi.signIn(
            usernameController.text, passwordController.text);
        print(result.data['token']);
        SharePreference.prefs.setString("token", result.data['token']);
        DioInstance.dio.options.headers["Authorization"] =
            "Bearer ${result.data}";
        if (result.data['role'] == 'admin') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavBar(
                        selectedIndex: 0,
                      )));
        }
      } on DioException catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      }
    }
  }

  User user = User('', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                    child: const Text(
                      'Sign in',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: usernameController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username";
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter a password';
                      } else if (val.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepPurple),
                            ),
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()))),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        const Text(
                          "If you don't have account.",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    )),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => signInHandler(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
