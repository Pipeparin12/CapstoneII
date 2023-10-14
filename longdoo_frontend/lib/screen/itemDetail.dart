import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:longdoo_frontend/model/clothes.dart';

import 'accountName/accName.dart';

class ItemDetailScreen extends StatefulWidget {
  final ClothingItem demoItem;
  ItemDetailScreen({required this.demoItem});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late int counter = 1;
  void increment() {
    setState(() {
      counter++;
    });
  }

  void decrement() {
    setState(() {
      if (counter == 0) {
        return null;
      } else {
        counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AccNameScreen();
              }));
            },
          )
        ],
      ),
      body
          // : isLoading
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          : Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .42,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.demoItem.imagePath),
                  fit: BoxFit.cover)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * .42,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.demoItem.name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 30),
                  child: Row(
                    children: [
                      Text(
                        "Price: " + widget.demoItem.price.toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 30),
                  child: Row(
                    children: [
                      Text(
                        "Amount : " + widget.demoItem.amount.toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 30),
                  child: Row(
                    children: [
                      Text(
                        "Color: " + widget.demoItem.color,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  margin:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product description",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.withOpacity(1)),
                        ),
                        SizedBox(height: 10),
                        Text(widget.demoItem.description),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                            height: 49,
                            width: 49,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: TextButton(
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                decrement();
                              },
                            )),
                          ),
                          Container(
                            height: 49,
                            width: 70,
                            child: Center(
                                child: Text(
                              '$counter',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                          ),
                          Container(
                            height: 49,
                            width: 49,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: TextButton(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              onPressed: () {
                                increment();
                              },
                            )),
                          ),
                        ],
                      )),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text('Add to cart',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        onTap: () {
                          // addToCart();
                        },
                      )
                      // GestureDetector(
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 10, horizontal: 20),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: Text('Add to cart'),
                      //   ),
                      //   onTap: () {
                      //     // addToCart();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
