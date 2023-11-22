import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class UserModelScreen extends StatefulWidget {
  const UserModelScreen({super.key});

  @override
  State<UserModelScreen> createState() => _UserModelScreenState();
}

class _UserModelScreenState extends State<UserModelScreen> {
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
  void initState() {
    fetchProfile().then((_) => Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile.model == "-") {
      return Center(
        child: Image.asset('assets/images/splash.jpg', fit: BoxFit.fitWidth),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Your Model"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return BottomNavBar(selectedIndex: 0,);
            }));
          },
        ),
      ),
      body: Container(
        color: Colors.black54,
        child: SizedBox(
          height: double.maxFinite,
          child: ModelViewer(
            src: 'assets/3D_models/${userProfile.model}.glb',
            autoPlay: true,
            autoRotate: false,
            cameraControls: true,
          ),
        ),
      ),
    );
  }
}
