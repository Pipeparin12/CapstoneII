import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/admin/account_management.dart';
import 'package:longdoo_frontend/screen/admin/history.dart';
import 'package:longdoo_frontend/screen/signin.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Setting'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: double.maxFinite,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccManagementScreen()));
                            },
                            child: Container(
                              width: 350,
                              height: 70,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.manage_accounts_outlined,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Account management",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderHistoryScreen()));
                            },
                            child: Container(
                              width: 350,
                              height: 70,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.history,
                                        color: Colors.deepOrangeAccent.shade200,
                                        size: 40,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "History",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.deepOrangeAccent.shade200,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                                (route) => false,
                              );
                            },
                            child: Container(
                              width: 350,
                              height: 70,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.power_settings_new,
                                    color: Colors.red.shade900,
                                    size: 40,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Log out",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.red.shade900,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
