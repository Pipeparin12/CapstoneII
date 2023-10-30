import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:longdoo_frontend/screen/cart.dart';
import 'package:longdoo_frontend/screen/try_on.dart';
import 'package:longdoo_frontend/service/api/cart.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class ItemDetailScreen extends StatefulWidget {
  final String id;

  ItemDetailScreen({required this.id});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  var listProduct;
  bool isLoading = true;
  late int counter = 1;
  String selectedSize = 'S';

  Future<void> getDetail() async {
    try {
      var result = await ProductApi.getDetail(widget.id);
      setState(() {
        listProduct = Map<String, dynamic>.from(result.data['product']);
      });
      print(result);
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getDetail().then((_) => Future.delayed(new Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        }));

    super.initState();
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
                return CartScreen();
              }));
            },
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .42,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            DioInstance.getImage(listProduct['productImage'])),
                        fit: BoxFit.cover)),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .42,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                listProduct['productName'],
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border_outlined),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 30),
                        child: Row(
                          children: [
                            Text(
                              "Price: ฿" +
                                  listProduct['price'].toStringAsFixed(0),
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
                              "Quantity : " +
                                  listProduct['quantity'].toStringAsFixed(0),
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
                              "Color: " + listProduct['color'],
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.withOpacity(0.2),
                        margin: EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 5),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product description",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.withOpacity(1)),
                              ),
                              SizedBox(height: 10),
                              Text(listProduct['productDescription']),
                            ],
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.checkroom,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text('Try on virtual clothes',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TryOnScreen()));
                              },
                            ),
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
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (
                                      context,
                                    ) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setModalState) {
                                        String productId = widget.id;
                                        void increment() {
                                          setModalState(() {
                                            counter++;
                                          });
                                        }

                                        void decrement() {
                                          setModalState(() {
                                            if (counter == 0) {
                                              return null;
                                            } else {
                                              counter--;
                                            }
                                          });
                                        }

                                        void addToCart() async {
                                          try {
                                            var result =
                                                await CartApi.addToCart(
                                                    counter,
                                                    productId,
                                                    selectedSize,
                                                    listProduct[
                                                        'productImage']);
                                            print(result);
                                          } catch (e) {
                                            print(e);
                                          }
                                        }

                                        return Container(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Quantity : " +
                                                        listProduct['quantity']
                                                            .toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              // Size selection
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Size:',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setModalState(() {
                                                        selectedSize = 'XS';
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.grey.shade400,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child: Text('XS'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setModalState(() {
                                                        selectedSize = 'S';
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.grey.shade400,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child: Text('S'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setModalState(() {
                                                        selectedSize = 'M';
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.grey.shade400,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child: Text('M'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setModalState(() {
                                                        selectedSize = 'L';
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.grey.shade400,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child: Text('L'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setModalState(() {
                                                        selectedSize = 'XL';
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.grey.shade400,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child: Text('XL'),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Amount',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
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
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.grey)),
                                                    child: Center(
                                                        child: TextButton(
                                                      onPressed: () {
                                                        decrement();
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
                                                            color:
                                                                Colors.grey)),
                                                    child: Center(
                                                        child: Text(
                                                      '$counter',
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
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.grey)),
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
                                                        increment();
                                                      },
                                                    )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  addToCart();
                                                  // print('$counter and ' +
                                                  //     selectedSize +
                                                  //     ' and ' +
                                                  //     productId);
                                                  Navigator.pop(
                                                      context); // Close the modal form
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.grey.shade400,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                child: Text('Confirm'),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );
                                })
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
