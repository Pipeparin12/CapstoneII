import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/signin.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

void main() {
  runApp(const MyApp());
  DioInstance.init();
  SharePreference.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: SignInPage());
  }
}
