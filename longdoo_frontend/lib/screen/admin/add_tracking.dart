import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:longdoo_frontend/model/order.dart';
import 'dart:io';
import 'package:longdoo_frontend/screen/admin/order_tracking.dart';
import 'package:longdoo_frontend/service/api/order.dart';
import 'package:longdoo_frontend/service/dio.dart';

class AddTrackingScreen extends StatefulWidget {
  final String orderId;
  const AddTrackingScreen({super.key, required this.orderId});

  @override
  State<AddTrackingScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<AddTrackingScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String imageUrl = '';
  late String productId;
  late int productQuantity;
  File? imageFile;
  final imagePicker = ImagePicker();
  double totalPriceSum = 0;
  bool isLoading = true;

  var orderData = {};
  var productData = [];

  List<String> shippingCompanies = ['EMS', 'Kerry Express', 'Flash Express'];
  String selectedShippingCompany = 'EMS';

  Order orderProfile = Order(
    id: "-",
    owner: "-",
    products: [],
    totalPrice: 0,
    shippingInformation: ShippingInformation(
        firstName: "-", lastName: "-", phone: "-", address: "-"),
    paymentInformation: PaymentInformation(slip: "-"),
    status: OrderStatus(status: "-", description: "-"),
  );

  final shippingController = TextEditingController();
  final trackingNumberController = TextEditingController();

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

  Future<void> updateTracking(String orderId, String description) async {
    try {
      var result = await OrderApi.updateTracking(widget.orderId, description);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderTrackingScreen(),
        ),
      );
      setState(() {
        print('Add success');
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  double calculateTotalPrice(Map<dynamic, dynamic> orderData) {
    double total = 0.0;

    if (orderData['products'] != null) {
      List<dynamic> products = orderData['products'];

      for (var product in products) {
        double totalPrice =
            double.tryParse(product['totalPrice'].toString()) ?? 0.0;
        total += totalPrice;
      }
    }

    return total;
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
          title: const Text('Your Details'),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: formState,
                  child: SizedBox(
                    height: double.maxFinite,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order ${widget.orderId}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (orderData['products'] != null)
                                for (var product in orderData['products'])
                                  Container(
                                    padding: const EdgeInsets.all(10),
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
                                                    DioInstance.getImage(product[
                                                            'productImage'] ??
                                                        ''),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product['productName'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Size: ${product['size']}",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Amount: ${product['quantity']}",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(
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
                                              '฿${product['totalPrice']}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
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
                                    '฿${calculateTotalPrice(orderData).toStringAsFixed(0)}', // Display the total order price
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Detail for shipping',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Add tracking number & shipping company',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  Container(
                                    width: 400,
                                    height: 200,
                                    decoration: const BoxDecoration(),
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Shipping Company',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 370,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value:
                                                        selectedShippingCompany,
                                                    items: shippingCompanies
                                                        .map((String company) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: company,
                                                        child: Text(company),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        selectedShippingCompany =
                                                            value!;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 10.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tracking number',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 370,
                                                  child: TextFormField(
                                                    controller:
                                                        trackingNumberController,
                                                    decoration: const InputDecoration(
                                                      border:
                                                          UnderlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  String description =
                                      "${trackingNumberController.text}, $selectedShippingCompany";
                                  updateTracking(widget.orderId, description);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade400,
                                  padding: const EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const SizedBox(
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
                ),
              ));
  }
}
