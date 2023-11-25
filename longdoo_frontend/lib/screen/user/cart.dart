import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/user/order/unpaid.dart';
import 'package:longdoo_frontend/service/api/cart.dart';
import 'package:longdoo_frontend/service/dio.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late int counter = 1;
  var cart = [];
  var currentCounter;

  Future<void> getYourCart() async {
    try {
      var result = await CartApi.getCart();
      print(result.data);
      setState(() {
        cart = result.data['cart'].toList();
      });
      print(cart);
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> checkout() async {
    try {
      var result = await CartApi.checkout();
    } on DioException catch (e) {
      print(e);
    }
  }

  void increment(int index) async {
    try {
      int currentCounter = cart[index]['quantity'];
      int price = cart[index]['price'];
      setState(() {
        cart[index]['quantity'] = currentCounter + 1;
        cart[index]['totalPrice'] = (currentCounter + 1) * price;
      });
      await CartApi.updateCartItemQuantity(cart[index]['productId'],
          cart[index]['size'], currentCounter + 1, cart[index]['productImage']);
    } on DioException catch (e) {
      print("Error incrementing quantity: $e");
      setState(() {
        cart[index]['quantity'] = currentCounter;
      });
    }
  }

  void decrement(int index) async {
    try {
      int currentCounter = cart[index]['quantity'];
      int price = cart[index]['price'];

      if (currentCounter > 1) {
        setState(() {
          cart[index]['quantity'] = currentCounter - 1;
          cart[index]['totalPrice'] = (currentCounter - 1) * price;
        });
        await CartApi.updateCartItemQuantity(
            cart[index]['productId'],
            cart[index]['size'],
            currentCounter - 1,
            cart[index]['productImage']);
      }
    } on DioException catch (e) {
      print("Error decrementing quantity: $e");
      setState(() {
        cart[index]['quantity'] = currentCounter;
      });
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
    getYourCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 550,
            child: Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.only(right: 5, left: 5, bottom: 10),
                            height: 130,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              DioInstance.getImage(
                                                  cart[index]['productImage'])),
                                          fit: BoxFit.cover,
                                        )),
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
                                            cart[index]['productName'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Size: " + cart[index]['size'],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Expanded(
                                              child: Container(
                                            margin: const EdgeInsets.all(0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey)),
                                                  child: Center(
                                                      child: TextButton(
                                                    onPressed: () {
                                                      decrement(index);
                                                    },
                                                    child: const Text(
                                                      '-',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey)),
                                                  child: Center(
                                                      child: Text(
                                                    cart[index]['quantity']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey)),
                                                  child: Center(
                                                      child: TextButton(
                                                    child: const Text(
                                                      '+',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      increment(index);
                                                    },
                                                  )),
                                                ),
                                              ],
                                            ),
                                          )),
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
                                          '฿ ${cart[index]['totalPrice']}',
                                          style: const TextStyle(
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 30,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -15),
                blurRadius: 20,
                color: const Color(0xFFDADADA).withOpacity(0.5),
              )
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price: ฿${calculateTotalPrice(cart).toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(140, 50),
                          ),
                          child: const Text(
                            "Purchase",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () async {
                            await checkout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UnpaidScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
