import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/screen/admin/admin_category.dart';
import 'package:longdoo_frontend/screen/admin/new_order.dart';
import 'package:longdoo_frontend/screen/admin/order_tracking.dart';
import 'package:longdoo_frontend/screen/admin/setting.dart';
import 'package:longdoo_frontend/screen/admin/shipment_confirm.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _listItems = [
    {
      'name': 'Men\'s Wear',
      'category': 'Male',
      'imagePath': 'assets/images/menswear.jpg',
    },
    {
      'name': 'Women\'s Wear',
      'category': 'Female',
      'imagePath': 'assets/images/womenswear.jpg',
    },
    {
      'name': 'Unisex',
      'category': 'Unisex',
      'imagePath': 'assets/images/unisex.png',
    },
    {
      'name': 'Sale',
      'imagePath': 'assets/images/sale.png',
    },
  ];
  var waiting = [];
  var packing = [];
  var onTheWay = [];
  String name = '';
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

  Future<void> getPacking() async {
    try {
      var result = await OrderApi.getPackingOrder();
      print(result.data);
      setState(() {
        packing = result.data['orders'].toList();
      });
      print(waiting);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getWaiting() async {
    try {
      var result = await OrderApi.getWaitingOrder();
      print(result.data);
      setState(() {
        waiting = result.data['orders'].toList();
      });
      print(packing);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getOnTheWay() async {
    try {
      var result = await OrderApi.getOnTheWayOrder();
      print(result.data);
      setState(() {
        onTheWay = result.data['orders'].toList();
      });
      print(packing);
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fetchProfile().then((_) => Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        }));
    getPacking();
    getWaiting();
    getOnTheWay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Image.asset('assets/images/splash.jpg', fit: BoxFit.fitWidth),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin LongDoo'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return SettingScreen();
              }));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'New Orders',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 350,
                            height: 70,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "New order",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewOrderScreen()));
                                      },
                                      child: Text(
                                        "see more",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: waiting.isNotEmpty,
                                  child: Positioned(
                                    right: 5,
                                    top: 5,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        waiting.length > 99
                                            ? '99+'
                                            : waiting.length.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 230,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Order Tracking',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 350,
                            height: 70,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Inform tracking number",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderTrackingScreen()));
                                      },
                                      child: Text(
                                        "see more",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: packing.isNotEmpty,
                                  child: Positioned(
                                    right: 5,
                                    top: 5,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        packing.length > 99
                                            ? '99+'
                                            : packing.length.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 350,
                            height: 70,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Confirm Shipment",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmShipmentScreen()));
                                      },
                                      child: Text(
                                        "see more",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: onTheWay.isNotEmpty,
                                  child: Positioned(
                                    right: 5,
                                    top: 5,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        onTheWay.length > 99
                                            ? '99+'
                                            : onTheWay.length.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 400,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Products',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0,
                                children: [
                              ...List.generate(
                                  _listItems.length,
                                  (index) => Container(
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminCategoryScreen(
                                                              name: _listItems[
                                                                      index]
                                                                  ['name'],
                                                              category: _listItems[
                                                                      index][
                                                                  'category'])));
                                            },
                                            child: Column(
                                              children: [
                                                Card(
                                                  color: Colors.transparent,
                                                  elevation: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            _listItems[index]
                                                                ["imagePath"]),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Transform.translate(
                                                      offset: Offset(57, -57),
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 65,
                                                          vertical: 65,
                                                        ),
                                                        child:
                                                            Transform.translate(
                                                          offset:
                                                              Offset(-3, -3),
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_border_outlined,
                                                              size: 0,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(_listItems[index]["name"])
                                              ],
                                            )),
                                      ))
                            ]))
                      ])),
            )
          ],
        ),
      ),
    );
  }
}
