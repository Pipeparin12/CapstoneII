import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';
import 'package:longdoo_frontend/service/share_preference.dart';

class CheckoutScreen extends StatefulWidget {
  final String orderId;
  const CheckoutScreen({super.key, required this.orderId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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

  void uploadSlips(BuildContext context) async {
    print("Uploading... " + imageFile!.path);
    final token = SharePreference.prefs.getString("token");
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imageFile!.path,
        filename: "fileName.jpg",
        contentType: MediaType('image', 'jpg'),
      ),
      "orderId": widget.orderId,
    });

    final response = await DioInstance.dio.post(
      "/storage/upload-slips",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);
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
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              if (orderData != null &&
                                  orderData['products'] != null)
                                for (var product in orderData['products'])
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['productName'],
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Size: ${product['size']}",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '\฿${product['totalPrice']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                              if (orderData != null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\฿${calculateTotalPrice(orderData).toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                        'User Information',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
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
                                      Text(
                                        'Purchase Order',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "88895478, Kasikorn",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Arron Brooklyn",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                width: 250,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 2, color: Colors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            pickedImage();
                                          },
                                          child: Expanded(
                                              child: imageFile == null
                                                  ? Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .add_photo_alternate_outlined,
                                                            size: 60,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            'Upload Slip Here',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Image.file(
                                                      imageFile!,
                                                      fit: BoxFit.fitHeight,
                                                      height: 350,
                                                      width: 400,
                                                    )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          uploadSlips(context);
                          for (int i = 0;
                              i < orderData['products'].length;
                              i++) {}
                          Navigator.pop(context);
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
                ),
              ));
  }
}
