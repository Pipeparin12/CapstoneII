import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class ClothesDetailScreen extends StatefulWidget {
  final String id;
  ClothesDetailScreen({required this.id});

  @override
  State<ClothesDetailScreen> createState() => _ClothesDetailScreenState();
}

class _ClothesDetailScreenState extends State<ClothesDetailScreen> {
  var listProduct;
  bool isLoading = true;

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
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              listProduct['productName'],
                              style: TextStyle(
                                fontSize: 25,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              "Price: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "฿" + listProduct['price'].toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              "Color: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              listProduct['color'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              "Size: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              listProduct['size'],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product description",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              listProduct['productDescription'],
                              style: TextStyle(fontSize: 16),
                            ),
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
