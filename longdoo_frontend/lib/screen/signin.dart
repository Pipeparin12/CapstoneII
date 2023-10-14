import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/screen/category.dart';
import 'package:longdoo_frontend/screen/home.dart';

class SignInPage extends StatelessWidget {
  static String routeName = "/sign_in";
  
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNavBar())),
          tooltip: 'Sign In',
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
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool? isLoading = false;
  bool? remember = false;

   void signInHandler() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        var result =
            await UserApi.signIn(emailController.text, passwordController.text);
        print(result.data['token']);
        SharePreference.prefs.setString("token", result.data['token']);
        DioInstance.dio.options.headers["Authorization"] =
            "Bearer ${result.data}";
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      } on DioError catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e);
      }
    }
  }

  User user = User('', '');

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
                  'Sign in',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: usernameControllerController,
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
        ));
  }
}
