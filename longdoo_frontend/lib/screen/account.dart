import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/signup/signUpScreen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Account'),
          centerTitle: true,
        ),
        body: Column(children: [
          Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 660,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hi, Jannette',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'First name',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Container(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Last name',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Container(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Container(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 10, right: 10),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(left: 40)),
                              Container(
                                width: 250,
                                child: GestureDetector(
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.deepPurple),
                                    ),
                                    onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()))),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Container(
                                width: 250,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, right: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Address',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(left: 20)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 360,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ])))
        ]));
  }
}
