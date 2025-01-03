import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/screen/user/all_clothes.dart';
import 'package:longdoo_frontend/screen/user/category.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  final List<Map<String, dynamic>> _listMaleItems = [
    {
      'name': 'Men\'s Wear',
      'category': 'Male',
      'productImage': 'assets/images/menswear.jpg',
    },
    {
      'name': 'Unisex',
      'category': 'Unisex',
      'productImage': 'assets/images/unisex.png',
    },
  ];

  final List<Map<String, dynamic>> _listFemaleItems = [
    {
      'name': 'Women\'s Wear',
      'category': 'Female',
      'productImage': 'assets/images/womenswear.jpg',
    },
    {
      'name': 'Unisex',
      'category': 'Unisex',
      'productImage': 'assets/images/unisex.png',
    },
  ];

  final String _searchQuery = '';

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

  List<Map<String, dynamic>> getSelectedList() {
    return (userProfile.gender == 'Male') ? _listMaleItems : _listFemaleItems;
  }

  @override
  void initState() {
    fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'LongDoo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 370,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/all-clothes.jpg'),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Center(
                              child: Text(
                            "Shop Now",
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllCategoryScreen(
                                name: 'Clothes',
                                category: userProfile.gender,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  children: getSelectedList()
                      .where((item) =>
                          _searchQuery.isEmpty ||
                          item['name']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                  name: item['name'],
                                  category: item['category'],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: AssetImage(item['productImage']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Transform.translate(
                                    offset: const Offset(30, -30),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 65,
                                        vertical: 63,
                                      ),
                                      child: const Icon(
                                        Icons.bookmark_border,
                                        size: 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
