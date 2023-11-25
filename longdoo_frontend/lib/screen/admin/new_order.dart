import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/admin/confirm_order.dart';
import 'package:longdoo_frontend/screen/admin/home_admin.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/dio.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  var order = [];
  bool isChecked = false;

  Future<void> getYourOrder() async {
    try {
      var result = await OrderApi.getWaitingOrder();
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
    getYourOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const AdminHomeScreen();
            }));
          },
        ),
        backgroundColor: Colors.white,
        title: const Text('New order'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 700,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: order.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order number: ' + order[index]['_id'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                if (order[index]['products'] != null &&
                                    order[index]['products'].isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.only(
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
                                                  DioInstance.getImage((order[
                                                              index]['products']
                                                          [0]['productImage'] ??
                                                      '')),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10, bottom: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    (order[index]['products'][0]
                                                            ['productName'] ??
                                                        ''),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Total Price: ฿${calculateTotalPrice(
                                                                order[index][
                                                                    'products'])
                                                            .toStringAsFixed(0)}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
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
                                                  ConfirmOrderScreen(
                                                      orderId: order[index]
                                                          ['_id'])));
                                    },
                                    child: const Text(
                                      'See more details',
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ),
                            const Divider(
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
