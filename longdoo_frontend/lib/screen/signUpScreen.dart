import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/user/userSize.dart';
import 'package:longdoo_frontend/service/api/user.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  bool remember = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();

  void signUpHandler() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      try {
        var signUpResult = await UserApi.signUp(
          usernameController.text,
          passwordController.text,
          firstnameController.text,
          lastnameController.text,
        );
        if (signUpResult.statusCode == 200) {
          var signInResult = await UserApi.signIn(
            usernameController.text,
            passwordController.text,
          );
          print(signInResult.data['token']);
          SharePreference.prefs.setString("token", signInResult.data['token']);
          DioInstance.dio.options.headers["Authorization"] =
              "Bearer ${signInResult.data}";
          if (signInResult.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserSizeScreen()),
            );
          } else {
            print("Sign-in failed");
          }
        } else {
          print("Sign-up failed");
        }
      } on DioException catch (e) {
        setState(() {
          isloading = false;
        });
        print(e);
      }
    }
  }

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
                      'Create your account',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: firstnameController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter firstname";
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Firstname',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: lastnameController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter lastname";
                      }
                      return null;
                    }),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Lastname',
                    ),
                  ),
                ),
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
                    child: const Text(
                      'People use real names on the app.',
                      style: TextStyle(fontSize: 15),
                    )),
                Container(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => signUpHandler(),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
