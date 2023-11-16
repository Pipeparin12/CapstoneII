import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class TryOnScreen extends StatefulWidget {
  final String path;
  final String id;
  const TryOnScreen({super.key, required this.path, required this.id});

  @override
  State<TryOnScreen> createState() => _UserModelScreenState();
}

class _UserModelScreenState extends State<TryOnScreen> {
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
        title: Text("Try On"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black54,
        child: SizedBox(
          height: double.maxFinite,
          child: ModelViewer(
            src: 'assets/3D_models/${widget.path}.glb',
            autoPlay: true,
            autoRotate: false,
            cameraControls: true,
          ),
        ),
      ),
    );
  }
}
