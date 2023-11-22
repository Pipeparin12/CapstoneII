import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/user/account.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';
import 'package:quickalert/quickalert.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool _showOldPassword = false;
  bool _showNewPassword = false;

  updatePassword(context) async {
    Map<String, dynamic> updatePassword = ({
      "currentPassword": oldPasswordController.text.trim(),
      "newPassword": newPasswordController.text.trim(),
    });

    try {
      final token = SharePreference.prefs.getString("token");
      final response = await DioInstance.dio.patch(
        "/password/change-password",
        data: updatePassword,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response.data);

      if (response.data["message"] == "Password changed successfully.") {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Password Changed Successfully!',
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountScreen()));
            });
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "There's a problem with changing your password.",
        autoCloseDuration: const Duration(seconds: 3),
        showConfirmBtn: false,
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Change Password'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Column(children: [
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
                              padding: const EdgeInsets.only(
                                  top: 30, right: 15, left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create new password',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Your new password must be different from previous used passwords.',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 360,
                                    child: TextFormField(
                                      controller: oldPasswordController,
                                      obscureText: !_showOldPassword,
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _showOldPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _showOldPassword =
                                                  !_showOldPassword;
                                            });
                                          },
                                        ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 360,
                                    child: TextFormField(
                                      controller: newPasswordController,
                                      obscureText: !_showNewPassword,
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _showNewPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _showNewPassword =
                                                  !_showNewPassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 40)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width: 200,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Save',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                  onTap: () => updatePassword(context),
                                )
                              ],
                            )
                          ])))
            ]),
          ),
        ));
  }
}
