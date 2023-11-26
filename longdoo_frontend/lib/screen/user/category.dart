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
  const CategoryScreen({required this.name, required this.category});

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
  List _filteredProducts = [];

  List _filterProducts(String query) {
    return listProduct.where((product) {
      final productName = product['productName'].toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _filteredProducts = _filterProducts(_searchQuery);
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
      body: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _filteredProducts = _filterProducts(_searchQuery);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                      ...List.generate(
                          _filteredProducts.length,
                          (index) => Container(
                                child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItemDetailScreen(
                                            id: _filteredProducts[index]['_id'],
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
                                                            _filteredProducts[
                                                                    index][
                                                                'productImage'])),
                                                    fit: BoxFit.cover)),
                                            child: Transform.translate(
                                              offset: const Offset(30, -30),
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 65,
                                                  vertical: 60,
                                                ),
                                                child: const Icon(
                                                  Icons.bookmark_border,
                                                  size: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _filteredProducts[index]['price']
                                                  .toStringAsFixed(0) +
                                              " ฿",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          _filteredProducts[index]
                                              ['productName'],
                                          style: const TextStyle(fontSize: 10),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                              ))
                    ]))
              ]))),
    );
  }
}
