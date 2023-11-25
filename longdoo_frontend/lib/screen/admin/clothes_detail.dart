import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:longdoo_frontend/service/api/product.dart';
import 'package:longdoo_frontend/service/dio.dart';

class ClothesDetailScreen extends StatefulWidget {
  final String id;
  const ClothesDetailScreen({super.key, required this.id});

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
    getDetail().then((_) => Future.delayed(const Duration(seconds: 1), () {
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
          ? const Center(
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
                            top: 20, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              listProduct['productName'],
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            const Text(
                              "Price: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "฿" + listProduct['price'].toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            const Text(
                              "Color: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              listProduct['color'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Row(
                          children: [
                            const Text(
                              "Size: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              listProduct['size'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 20, right: 30, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Product description",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              listProduct['productDescription'],
                              style: const TextStyle(fontSize: 16),
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
