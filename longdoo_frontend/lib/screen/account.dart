import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/screen/changePW.dart';
import 'package:longdoo_frontend/screen/menu.dart';
import 'package:longdoo_frontend/screen/signin.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = true;
  Profile userProfile = Profile(
      username: "-",
      firstName: "-",
      lastName: "-",
      address: "-",
      phone: "-",
      height: 0,
      weight: 0,
      chestSize: 0,
      waistSize: 0,
      hipsSize: 0,
      gender: "-",
      size: "-",
      model: "-");

  late String address;
  late String phone;

  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  getPhoneNum(String pnum) {
    phone = pnum;
  }

  getAddressName(String aname) {
    address = aname;
  }

  updateProfile(context) async {
    Map<String, dynamic> updatedProfile = ({
      "phone": phoneController.text.trim(),
      "address": addressController.text.trim(),
    });

    print("Updated Phone: ${updatedProfile['phone']}");
    print("Updated Address: ${updatedProfile['address']}");

    try {
      final token = SharePreference.prefs.getString("token");
      final response = await DioInstance.dio.patch(
        "/account/userdetails/update",
        data: updatedProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response.data);

      if (response.data["success"]) {
        await fetchProfile();
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchProfile() async {
    final token = SharePreference.prefs.getString("token");
    final response = await DioInstance.dio.get(
      "/account/userdetails",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    if (response.data["success"]) {
      final profileData = response.data["userProfile"];
      if (profileData != null) {
        setState(() {
          userProfile = Profile.fromJson(profileData);
        });
      } else {}
    } else {}
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    isLoading = true;

    fetchProfile().then((_) {
      phoneController.text = userProfile.phone;
      addressController.text = userProfile.address;
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Account'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Column(children: [
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
                              padding:
                                  const EdgeInsets.only(top: 20, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Edit your information',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name',
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
                                        child: TextFormField(
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: userProfile.firstName +
                                                  ' ' +
                                                  userProfile.lastName),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Username',
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
                                        child: TextFormField(
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: userProfile.username),
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 10, right: 10),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Password',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
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
                                                        ChangePasswordScreen()))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Phone',
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
                                        child: TextFormField(
                                          controller: phoneController,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        child: TextFormField(
                                          controller: addressController,
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
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: GestureDetector(
                                      child: Text(
                                        "Log out",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.deepPurple),
                                      ),
                                      onTap: () => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignInPage()))),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 40)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
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
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  onTap: () => updateProfile(context),
                                )
                              ],
                            )
                          ])))
            ]),
          ),
        ));
  }
}
