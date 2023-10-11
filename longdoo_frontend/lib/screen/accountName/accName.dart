import 'package:flutter/material.dart';

class AccNameScreen extends StatelessWidget {
  const AccNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(context);
            print(context);
          },
          tooltip: 'Enter your fullname',
          child: Icon(
            Icons.east,
            color: Color(0xFFFFFFFF),
          ),
          backgroundColor: Color(0xFF4A4A4A),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                child: const Text(
                  "What's your fullname ?",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
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
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Lastname',
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
        ));
  }
}
