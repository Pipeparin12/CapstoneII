import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/admin/add_clothes.dart';
import 'package:longdoo_frontend/screen/admin/clothes_detail.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class AdminCategoryScreen extends StatefulWidget {
  final String name;
  final String category;
  const AdminCategoryScreen({required this.name, required this.category});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  String name = '';
  var listProduct = [];

  Future<void> getProduct() async {
    try {
      var result = await ProductApi.getProduct(widget.category);
      final responseData = result.data;
      setState(() {
        listProduct = responseData;
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getProduct();
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
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const AddClothesScreen();
              }));
            },
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
                                                ClothesDetailScreen(
                                                    id: _filteredProducts[index]
                                                        ['_id']))),
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
                                        Text(
                                          "size: " +
                                              _filteredProducts[index]['size'],
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
