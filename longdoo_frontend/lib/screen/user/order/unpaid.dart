import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/model/product.dart';
import 'package:longdoo_frontend/screen/user/checkout.dart';
import 'package:longdoo_frontend/screen/user/order/processing.dart';
import 'package:longdoo_frontend/screen/user/order/shipped.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/dio.dart';

class UnpaidScreen extends StatefulWidget {
  @override
  _UnpaidScreenState createState() => _UnpaidScreenState();
}

class _UnpaidScreenState extends State<UnpaidScreen> {
  var order = [];
  bool isChecked = false;

  Future<void> getYourOrder() async {
    try {
      var result = await OrderApi.getUnpaidOrder();
      print(result.data);
      setState(() {
        order = result.data['orders'].toList();
      });
      print(order);
    } on DioException catch (e) {
      print(e);
    }
  }

  double calculateTotalPrice(List<dynamic> cart) {
    double totalPriceSum = 0.0;

    for (var item in cart) {
      double itemTotalPrice =
          double.tryParse(item['totalPrice'].toString()) ?? 0.0;
      totalPriceSum += itemTotalPrice;
    }

    return totalPriceSum;
  }

  @override
  void initState() {
    super.initState();
    getYourOrder(); // Call the function to fetch your orders
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to a specific route
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return BottomNavBar();
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
          height: 550,
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
                          // Add navigation logic for the "Unpaid" button
                        },
                        child: Text(
                          'To Pay',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProcessingScreen(),
                            ),
                          );
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
                                  'Status: Unpaid',
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
                            Row(
                              children: [
                                Text(
                                  "Total Price: ฿" +
                                      calculateTotalPrice(
                                              order[index]['products'])
                                          .toStringAsFixed(0),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen(
                                                      orderId: order[index]
                                                          ['_id'])));
                                    },
                                    child: Text(
                                      'Purchase now',
                                      style: TextStyle(color: Colors.black),
                                    )),
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
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.symmetric(
      //     vertical: 15,
      //     horizontal: 30,
      //   ),
      //   // height: 174,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30),
      //       topRight: Radius.circular(30),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         offset: Offset(0, -15),
      //         blurRadius: 20,
      //         color: Color(0xFFDADADA).withOpacity(0.5),
      //       )
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         SizedBox(height: 10),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               "Total Price: \$100",
      //               style:
      //                   TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //             ), // Replace with your total price text
      //             GestureDetector(
      //               behavior: HitTestBehavior.translucent,
      //               onTap: () {},
      //               child: Container(
      //                 padding: EdgeInsets.all(
      //                     10), // Adjust the padding to increase the tappable area
      //                 child: ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     minimumSize: Size(
      //                         140, 50), // Adjust the minimum size as needed
      //                   ),
      //                   child: Text(
      //                     "Purchase",
      //                     style: TextStyle(fontSize: 18),
      //                   ),
      //                   onPressed: () {},
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // )
    );
  }
}
