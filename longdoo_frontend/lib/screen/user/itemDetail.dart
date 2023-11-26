import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/user/cart.dart';
import 'package:longdoo_frontend/screen/user/try_on.dart';
import 'package:longdoo_frontend/service/api/bookmark.dart';
import 'package:longdoo_frontend/service/api/cart.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class ItemDetailScreen extends StatefulWidget {
  final String id;
  const ItemDetailScreen({super.key, required this.id});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  var listProduct;
  bool isLoading = true;
  late int counter = 1;
  String selectedSize = 'S';
  var cart = [];

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

  void addBookmark() async {
    try {
      var result = await BookmarkApi.addToBookmark(
          listProduct['productImage'], listProduct['_id']);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getYourCart() async {
    try {
      var result = await CartApi.getCart();
      print(result.data);
      setState(() {
        print('Before update: $cart');
        cart = result.data['cart'].toList();
        print('After update: $cart');
      });
      print(cart);
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getDetail().then((_) => Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading = false;
          });
        }));
    getYourCart().then((_) => Future.delayed(const Duration(seconds: 1), () {
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
            Stack(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.shopping_bag,
                    size: 30,
                  ),
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const CartScreen();
                    }));
                    getYourCart();
                  },
                ),
                Visibility(
                  visible: cart.isNotEmpty,
                  child: Positioned(
                    right: 3,
                    top: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 10,
                      child: Text(
                        cart.length > 99 ? '99+' : cart.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(DioInstance.getImage(
                                listProduct['productImage'])),
                            fit: BoxFit.cover)),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .45,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    listProduct['productName'],
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.favorite_border_outlined),
                                  onPressed: () {
                                    addBookmark();
                                  },
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 30),
                            child: Row(
                              children: [
                                Text(
                                  "Price: ฿" +
                                      listProduct['price'].toStringAsFixed(0),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 30),
                            child: Row(
                              children: [
                                Text(
                                  "Color: " + listProduct['color'],
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 30),
                            child: Row(
                              children: [
                                Text(
                                  "Size: " + listProduct['size'],
                                  style: const TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.2),
                            margin: const EdgeInsets.only(
                                top: 10, left: 20, right: 20, bottom: 5),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product description",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.withOpacity(1)),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    listProduct['productDescription'],
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(0)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.checkroom,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text('Try on virtual clothes',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TryOnScreen(
                                                  path: listProduct[
                                                      "productModel"],
                                                  id: widget.id,
                                                )));
                                  },
                                ),
                                GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text('Add to cart',
                                              style: TextStyle(
                                                  color: Colors.white)),
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
                                                  return;
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
                                                        listProduct['size'],
                                                        listProduct[
                                                            'productImage']);
                                                print(result);
                                                getYourCart();

                                                Navigator.pop(context);

                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemDetailScreen(
                                                            id: widget.id,
                                                          )),
                                                );
                                              } catch (e) {
                                                print(e);
                                              }
                                            }

                                            return Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Quantity : " +
                                                            listProduct[
                                                                    'quantity']
                                                                .toStringAsFixed(
                                                                    0),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
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
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Size: ${listProduct['size']}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Divider(
                                                    color: Colors.black,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      'Amount',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10)),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey)),
                                                        child: Center(
                                                            child: TextButton(
                                                          onPressed: () {
                                                            decrement();
                                                          },
                                                          child: const Text(
                                                            '-',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
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
                                                                color: Colors
                                                                    .grey)),
                                                        child: Center(
                                                            child: Text(
                                                          '$counter',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey)),
                                                        child: Center(
                                                            child: TextButton(
                                                          child: const Text(
                                                            '+',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            increment();
                                                          },
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      addToCart();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.grey.shade400,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child:
                                                        const Text('Confirm'),
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
              ));
  }
}
