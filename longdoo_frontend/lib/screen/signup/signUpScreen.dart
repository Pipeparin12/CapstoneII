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
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                  child: const Text(
                    'Create your account',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: firstnameController,
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
                child: TextField(
                  controller: lastnameController,
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
                child: TextField(
                  controller: usernameController,
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
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
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
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => signUpHandler(),
        tooltip: 'Sign Up',
        child: Icon(
          Icons.east,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: Color(0xFF4A4A4A),
      ),
    );
  }
}
