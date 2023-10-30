import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/model/product.dart';
import 'package:longdoo_frontend/screen/order/processing.dart';
import 'package:longdoo_frontend/screen/order/shipped.dart';

class UnpaidScreen extends StatefulWidget {
  @override
  _UnpaidScreenState createState() => _UnpaidScreenState();
}

class _UnpaidScreenState extends State<UnpaidScreen> {
  bool isChecked = false;
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
          title: Text('Order Unpaid'),
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
                            'Unpaid',
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
                            'Processing',
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
                            'Shipped',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(right: 5, left: 5, bottom: 10),
                            height: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  OrderCheckbox(),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/one.jpg'),
                                      width: 100, // Set the desired width
                                      height: 120, // Set the desired height
                                      fit: BoxFit
                                          .cover, // Adjust the fit as needed
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            'name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text("In cart: " + '2'),
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
                                          '\$10.99', // Replace with the actual price
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
                      "Total Price: \$100",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ), // Replace with your total price text
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
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
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {},
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

class OrderCheckbox extends StatefulWidget {
  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<OrderCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Checkbox(
        value: isChecked,
        onChanged: (newValue) {
          setState(() {
            isChecked = newValue ?? false;
          });
        },
      ),
    );
  }
}
