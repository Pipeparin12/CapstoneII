import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/signin.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/index_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
              child: const Text(
                'Welcome Jannette',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 35,
                    color: Color(0xFFFFFFFF)),
              )),
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: const Text(
                'to longDoo',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Color(0xFFFFFFFF)),
              )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SignInPage())),
        tooltip: 'Enter your fullname',
        backgroundColor: const Color(0xFF4A4A4A),
        child: const Icon(
          Icons.east,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
