import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/screen/user/order/shipped.dart';
import 'package:longdoo_frontend/screen/user/order/unpaid.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/dio.dart';

class ProcessingScreen extends StatefulWidget {
  @override
  _ProcessingScreenState createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  var order = [];
  bool isChecked = false;

  Future<void> getYourOrder() async {
    try {
      var result = await OrderApi.getProcessOrder();
      print(result.data);
      setState(() {
        order = result.data['orders'].toList();
      });
      print(order);
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getYourOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return BottomNavBar(selectedIndex: 2);
            }));
          },
        ),
        backgroundColor: Colors.white,
        title: Text('My Purchases'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 680,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnpaidScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'To Pay',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // No navigate because on this page already.
                        },
                        child: Text(
                          'To Ship',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShippedScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'To Receive',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: order.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Status: ' + order[index]['status']['status'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Tracking Number: ' +
                                      order[index]['status']['description'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Order number: ' + order[index]['_id'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                for (var product
                                    in order[index]['products'] ?? '')
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: 5, left: 5, bottom: 10),
                                    height: 120,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Container(
                                            width: 110,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  DioInstance.getImage((product[
                                                          'productImage'] ??
                                                      '')),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 10, bottom: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    (product['productName'] ??
                                                        ''),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Size: " +
                                                        (product['size'] ?? ""),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Amount: " +
                                                        (product['quantity']
                                                                .toString() ??
                                                            ""),
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '\฿ ' +
                                                      (product['totalPrice']
                                                              .toString() ??
                                                          ''),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
