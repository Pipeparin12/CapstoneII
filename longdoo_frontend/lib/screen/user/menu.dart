import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/profile.dart';
import 'package:longdoo_frontend/screen/user/account.dart';
import 'package:longdoo_frontend/screen/user/cart.dart';
import 'package:longdoo_frontend/screen/user/itemDetail.dart';
import 'package:longdoo_frontend/screen/user/order/processing.dart';
import 'package:longdoo_frontend/screen/user/order/shipped.dart';
import 'package:longdoo_frontend/screen/user/order/unpaid.dart';
import 'package:longdoo_frontend/screen/user/support.dart';
import 'package:longdoo_frontend/screen/user/userSize.dart';
import 'package:longdoo_frontend/service/api/bookmark.dart';
import 'package:longdoo_frontend/service/api/cart.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var bookmark = [];
  var cart = [];
  var unpaid = [];
  var process = [];
  var shipped = [];
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

  Future<void> getYourBookmark() async {
    try {
      var result = await BookmarkApi.getBookmark();
      print(result.data);
      setState(() {
        bookmark = result.data['bookmarks'].toList();
      });
      print(bookmark);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      var result = await BookmarkApi.deleteBookmark(bookmarkId);
      getYourBookmark();
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getYourCart() async {
    try {
      var result = await CartApi.getCart();
      print(result.data);
      setState(() {
        print('Before update: $cart');
        cart = result.data['cart'].toList();
        print('After update: $cart');
      });
      print(cart);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getYourUnpaid() async {
    try {
      var result = await OrderApi.getUnpaidOrder();
      print(result.data);
      setState(() {
        unpaid = result.data['orders'].toList();
      });
      print(unpaid);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getYourProcess() async {
    try {
      var result = await OrderApi.getProcessOrder();
      print(result.data);
      setState(() {
        process = result.data['orders'].toList();
      });
      print(process);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getYourShipped() async {
    try {
      var result = await OrderApi.getShippedOrder();
      print(result.data);
      setState(() {
        shipped = result.data['orders'].toList();
      });
      print(shipped);
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
    getYourBookmark()
        .then((value) => Future.delayed(const Duration(seconds: 1), (() {
              setState(() {
                isLoading = false;
              });
            })));
    getYourCart().then((_) => Future.delayed(new Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        }));
    getYourUnpaid();
    getYourProcess();
    getYourShipped();
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag,
                  size: 30,
                ),
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return CartScreen();
                  }));
                  getYourCart();
                },
              ),
              Visibility(
                visible: cart.isNotEmpty,
                child: Positioned(
                  right: 3,
                  top: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      cart.length > 99 ? '99+' : cart.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Hi, ${userProfile.firstName}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Informations & Services',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserSizeScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.emoji_people,
                                  size: 35,
                                ),
                              ),
                              Text(
                                'Your Size',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SupportScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.support_agent,
                                  size: 35,
                                ),
                              ),
                              Text(
                                'Support',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccountScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.manage_accounts,
                                  size: 35,
                                ),
                              ),
                              Text(
                                'Account',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 140,
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
                            'My Orders',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.account_balance_wallet,
                                      size: 35,
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return UnpaidScreen();
                                      }));
                                      getYourCart();
                                    },
                                  ),
                                  Visibility(
                                    visible: unpaid.isNotEmpty,
                                    child: Positioned(
                                      right: 0,
                                      top: 3,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 10,
                                        child: Text(
                                          cart.length > 99
                                              ? '99+'
                                              : unpaid.length.toString(),
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
                              Text(
                                'Unpaid',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.pallet,
                                      size: 35,
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ProcessingScreen();
                                      }));
                                      getYourCart();
                                    },
                                  ),
                                  Visibility(
                                    visible: process.isNotEmpty,
                                    child: Positioned(
                                      right: 0,
                                      top: 3,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 10,
                                        child: Text(
                                          process.length > 99
                                              ? '99+'
                                              : process.length.toString(),
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
                              Text(
                                'Process',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.pallet,
                                      size: 35,
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ShippedScreen();
                                      }));
                                      getYourCart();
                                    },
                                  ),
                                  Visibility(
                                    visible: shipped.isNotEmpty,
                                    child: Positioned(
                                      right: 0,
                                      top: 3,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 10,
                                        child: Text(
                                          shipped.length > 99
                                              ? '99+'
                                              : shipped.length.toString(),
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
                              Text(
                                'Shipped',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
              height: 280,
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
                                'Wishlist',
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
                                  bookmark.length,
                                  (index) => Container(
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ItemDetailScreen(
                                                      id: bookmark[index]
                                                          ['_id'],
                                                    ),
                                                  ));
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
                                                        image: NetworkImage(
                                                            DioInstance.getImage(
                                                                bookmark[index][
                                                                    'productImage'])),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child: Transform.translate(
                                                      offset: Offset(57, -57),
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 65,
                                                          vertical: 65,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white,
                                                        ),
                                                        child:
                                                            Transform.translate(
                                                          offset:
                                                              Offset(-3, -3),
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_border_outlined,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              deleteBookmark(
                                                                  bookmark[
                                                                          index]
                                                                      ['_id']);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
