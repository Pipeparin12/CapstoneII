import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/product.dart';
import 'package:longdoo_frontend/screen/accountName/accName.dart';
import 'package:longdoo_frontend/screen/order/processing.dart';
import 'package:longdoo_frontend/screen/order/unpaid.dart';

class ShippedScreen extends StatefulWidget {
  @override
  _ShippedScreenState createState() => _ShippedScreenState();
}

class _ShippedScreenState extends State<ShippedScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Shipped'),
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
                          // Add navigation logic for the "Shipped" button
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
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Status: shipped',
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
                            'Order number: 85f893w ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Image(
                                    image: AssetImage('assets/images/one.jpg'),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
