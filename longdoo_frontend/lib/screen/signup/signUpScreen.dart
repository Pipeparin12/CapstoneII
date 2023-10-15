import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/screen/accountName/accName.dart';
import 'package:longdoo_frontend/screen/category.dart';
import 'package:longdoo_frontend/screen/home.dart';
import 'package:longdoo_frontend/screen/signin.dart';
import 'package:longdoo_frontend/service/api/user.dart';

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
        var result = await UserApi.signUp(
            usernameController.text,
            passwordController.text,
            firstnameController.text,
            lastnameController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
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
                      // onPressed: () {
                      //   print(nameController.text);
                      //   print(passwordController.text);
                      // },
                    )),
                FloatingActionButton(
                  onPressed: () => signUpHandler(),
                  tooltip: 'Sign Up',
                  child: Icon(
                    Icons.east,
                    color: Color(0xFFFFFFFF),
                  ),
                  backgroundColor: Color(0xFF4A4A4A),
                ),
              ],
            ),
          )),
    );
  }
}
