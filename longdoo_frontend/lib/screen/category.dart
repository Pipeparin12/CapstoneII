import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/bottomNavBar.dart';
import 'package:longdoo_frontend/screen/cart.dart';
import 'package:longdoo_frontend/screen/itemDetail.dart';
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
  var listProduct = [];
  String name = '';

  Future<void> getProduct() async {
    try {
      var result = await ProductApi.getProduct(widget.category);
      final responseData = result.data;

      if (responseData is List) {
        // Handle the case where 'responseData' is a list
        setState(() {
          listProduct =
              responseData; // Assuming 'responseData' is a list of products
        });
      } else {
        // Handle other data types as needed
        // For example, set listProduct to an empty list or handle the error
      }
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
                Container(
                  width: 370,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage('assets/images/one.jpg'),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.4),
                              Colors.black.withOpacity(.2),
                            ])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Best Seller",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Center(
                              child: Text(
                            "Shop Now",
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
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
                                              offset: Offset(50, -50),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 65,
                                                  vertical: 60,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.bookmark_border,
                                                  size: 15,
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
