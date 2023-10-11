import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/signup/signUpScreen.dart';

import 'screen/index.dart';

void main() {
  runApp(const MyApp());
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
        home: IndexScreen());
  }
}
