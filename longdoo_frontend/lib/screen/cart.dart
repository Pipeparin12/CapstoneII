import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/checkout.dart';
import 'package:longdoo_frontend/screen/order/unpaid.dart';
import 'package:longdoo_frontend/service/api/cart.dart';
import 'package:longdoo_frontend/service/dio.dart';

class CartScreen extends StatefulWidget {
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
      // Get the current counter value for the selected item
      int currentCounter = cart[index]['quantity'];
      int price = cart[index]['price'];

      // Increase the quantity of the selected item in the cart locally
      setState(() {
        cart[index]['quantity'] = currentCounter + 1;
        cart[index]['totalPrice'] = (currentCounter + 1) * price;
      });

      // Make an API call to update the quantity in the database
      await CartApi.updateCartItemQuantity(
          cart[index][
              'productId'], // Replace with the actual product ID field in your cart item
          cart[index]['size'],
          currentCounter + 1, // Send the updated quantity to the server
          cart[index]['productImage']);
    } on DioException catch (e) {
      // Handle API error
      print("Error incrementing quantity: $e");
      // Revert the local change if the API call fails
      setState(() {
        cart[index]['quantity'] = currentCounter;
      });
    }
  }

  void decrement(int index) async {
    try {
      // Get the current counter value for the selected item
      int currentCounter = cart[index]['quantity'];
      int price = cart[index]['price'];

      if (currentCounter > 1) {
        // Decrease the quantity of the selected item in the cart locally
        setState(() {
          cart[index]['quantity'] = currentCounter - 1;
          cart[index]['totalPrice'] = (currentCounter - 1) * price;
        });

        // Make an API call to update the quantity in the database
        await CartApi.updateCartItemQuantity(
            cart[index][
                'productId'], // Replace with the actual product ID field in your cart item
            cart[index]['size'],
            currentCounter - 1, // Send the updated quantity to the server
            cart[index]['productImage']);
      }
    } on DioException catch (e) {
      // Handle API error
      print("Error decrementing quantity: $e");
      // Revert the local change if the API call fails
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
          title: Text('Cart'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 550,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(right: 5, left: 5, bottom: 10),
                            height: 130,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    width: 110, // Set the desired width
                                    height: 110, // Set the desired height
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              DioInstance.getImage(
                                                  cart[index]['productImage'])),

                                          fit: BoxFit
                                              .cover, // Adjust the fit as needed)
                                        )),
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
                                            cart[index]['productName'],
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Size: " + cart[index]['size'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Expanded(
                                              child: Container(
                                            margin: EdgeInsets.all(0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
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
                                                    child: Text(
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
                                                    style: TextStyle(
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
                                                          BorderRadius.only(
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
                                                    child: Text(
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
                                          '\฿ ' +
                                              cart[index]['totalPrice']
                                                  .toString(), // Replace with the actual price
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 30,
          ),
          // height: 174,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -15),
                blurRadius: 20,
                color: Color(0xFFDADADA).withOpacity(0.5),
              )
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price: ฿" +
                          calculateTotalPrice(cart).toStringAsFixed(0),
                      style: TextStyle(fontSize: 18),
                    ), // Replace with your total price text
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CheckoutScreen(
                        //       orderId: orderId,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                            10), // Adjust the padding to increase the tappable area
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                140, 50), // Adjust the minimum size as needed
                          ),
                          child: Text(
                            "Purchase",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () async {
                            await checkout(); // Wait for checkout to complete
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UnpaidScreen()),
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
