import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/user/cart.dart';
import 'package:longdoo_frontend/screen/user/itemDetail.dart';
import 'package:longdoo_frontend/service/api/cart.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class CategoryScreen extends StatefulWidget {
  final String name;
  final String category;
  CategoryScreen({Key? key, required this.name, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var cart = [];
  String name = '';

  var listProduct = [];

  Future<void> getProduct() async {
    try {
      var result = await ProductApi.getBySize(widget.category);
      final responseData = result.data;
      setState(() {
        listProduct = responseData['products'] ?? [];
      });
    } on DioException catch (e) {
      print(e);
    }
  }

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

  @override
  void initState() {
    getProduct();
    getYourCart();
    super.initState();
  }

  String _searchQuery = '';

  List _filterProducts(String query) {
    return listProduct.where((product) {
      final productName = product['productName'].toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
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
                    return CartScreen();
                  }));
                  getYourCart();
                },
              ),
              Visibility(
                visible: cart
                    .isNotEmpty, // Show the Positioned widget only if the cart is not empty
                child: Positioned(
                  right: 3,
                  top: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      cart.length > 99 ? '99+' : cart.length.toString(),
                      style: TextStyle(
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
      body: SingleChildScrollView(
          child: SizedBox(
              height: 700,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                      ...List.generate(
                          listProduct.length,
                          (index) => Container(
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItemDetailScreen(
                                            id: listProduct[index]['_id'],
                                          ),
                                        )),
                                    child: Column(
                                      children: [
                                        Card(
                                          color: Colors.transparent,
                                          elevation: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        DioInstance.getImage(
                                                            listProduct[index][
                                                                'productImage'])),
                                                    fit: BoxFit.cover)),
                                            child: Transform.translate(
                                              offset: Offset(30, -30),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 65,
                                                  vertical: 60,
                                                ),
                                                child: Icon(
                                                  Icons.bookmark_border,
                                                  size: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          listProduct[index]['price']
                                                  .toStringAsFixed(0) +
                                              " ฿",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          listProduct[index]['productName'],
                                          style: TextStyle(fontSize: 10),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                              ))
                      // ClothesCard(
                      //     productFromApi: listProduct[index],
                      // press: () => Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => ItemDetailScreen(
                      //         ),
                      //       ),
                      //         ))
                    ]))
              ]))),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
