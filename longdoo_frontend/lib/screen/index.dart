import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/signup/signUpScreen.dart';

class IndexScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
          // Container(
          //     height: 50,
          //     padding: const EdgeInsets.fromLTRB(10, 10, 200, 0),
          //     child: ElevatedButton(
          //       child: const Text('START'),
          //       onPressed: () => Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => SignUpPage())),
          //     )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUpPage())),
        tooltip: 'Enter your fullname',
        child: Icon(
          Icons.east,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: Color(0xFF4A4A4A),
      ),
    );
  }
}