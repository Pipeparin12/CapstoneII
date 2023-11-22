import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:longdoo_frontend/screen/admin/new_order.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final String orderId;
  const ConfirmOrderScreen({super.key, required this.orderId});

  @override
  State<ConfirmOrderScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<ConfirmOrderScreen> {
  String imageUrl = '';
  late String productId;
  late int productQuantity;
  File? imageFile;
  final imagePicker = ImagePicker();
  double totalPriceSum = 0;
  bool isLoading = true;

  var orderData = {};
  var productData = [];

  Future<void> getDetail() async {
    try {
      var result = await OrderApi.getOrderById(widget.orderId);
      setState(() {
        orderData = result.data['order'];
      });
      print(orderData);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> getProduct() async {
    try {
      setState(() {
        productData = List.from(orderData['products']);
      });
      print(productData);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> updateQuantity() async {
    try {
      print(productId);
      var result = await ProductApi.updateQuantity(productId, productQuantity);
      setState(() {
        print('Update successfully');
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  double calculateTotalPrice(Map<dynamic, dynamic> orderData) {
    double total = 0.0;

    if (orderData != null && orderData['products'] != null) {
      List<dynamic> products = orderData['products'];

      for (var product in products) {
        double totalPrice =
            double.tryParse(product['totalPrice'].toString()) ?? 0.0;
        total += totalPrice;
      }
    }

    return total;
  }

  void pickedImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        imageFile = File(pick.path);
      } else {
        imageFile = null;
      }
    });
  }

  Future<void> updateStatus() async {
    try {
      print(widget.orderId);
      var result = await OrderApi.updateStatus(widget.orderId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewOrderScreen(),
        ),
      );
      setState(() {
        print('Update successfully');
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetail().then((_) => Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        }));
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Your Details'),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  height: double.maxFinite,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ${widget.orderId}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (orderData != null &&
                                orderData['products'] != null)
                              for (var product in orderData['products'])
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 110,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  DioInstance.getImage(
                                                      product['productImage'] ??
                                                          ''),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product['productName'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Size: ${product['size']}",
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Amount: ${product['quantity']}",
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\฿${product['totalPrice']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            SizedBox(height: 5),
                            if (orderData != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\฿${calculateTotalPrice(orderData).toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            Divider(
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detail for shipping',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${orderData['shippingInformation']['firstName']} ${orderData['shippingInformation']['lastName']}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  "Phone: ${orderData['shippingInformation']['phone']}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  "Address: ${orderData['shippingInformation']['address']}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Proof of payment',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            Container(
                              width: 250,
                              height: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    DioInstance.getImage(
                                        orderData['paymentInformation']
                                                ['slip'] ??
                                            ''),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                updateStatus();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade400,
                                padding: EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 200,
                                child: Center(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
