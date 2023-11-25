import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:longdoo_frontend/service/api/product.dart';

class AddClothesScreen extends StatefulWidget {
  const AddClothesScreen({super.key});

  @override
  State<AddClothesScreen> createState() => _AddClothesScreenState();
}

class _AddClothesScreenState extends State<AddClothesScreen> {
  final _formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final imagePicker = ImagePicker();
  File? imageFile;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final colorController = TextEditingController();
  final quantityController = TextEditingController();

  List<String> size = ['S', 'M', 'L', 'XL'];
  String selectedSize = 'S';
  List<String> category = ['Male', 'Female'];
  String selectedCategory = 'Male';

  void addProduct() async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile!.path,
          filename: "fileName.jpg",
          contentType: MediaType("image", "jpg"),
        ),
        "productName": nameController.text,
        "productDescription": descriptionController.text,
        "price": int.parse(priceController.text),
        "color": colorController.text,
        "size": selectedSize,
        "quantity": int.parse(quantityController.text),
        "category": selectedCategory,
      });
      var result = await ProductApi.addProduct(formData);
    } catch (e) {}
  }

  void pickedImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        imageFile = File(pick.path);
      } else {
        imageFile = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Add product'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                        child: SizedBox(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 850,
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      width: 350,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  pickedImage();
                                                                },
                                                                child: Expanded(
                                                                  child: imageFile ==
                                                                          null
                                                                      ? const Center(
                                                                          child:
                                                                              Icon(
                                                                            Icons.add_photo_alternate_outlined,
                                                                            size:
                                                                                60,
                                                                          ),
                                                                        )
                                                                      : Image
                                                                          .file(
                                                                          imageFile!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              350,
                                                                          width:
                                                                              350,
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    controller: nameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Name',
                                                      border:
                                                          UnderlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 200,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            priceController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Price',
                                                          border:
                                                              UnderlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Container(
                                                      width: 200,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            quantityController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Quantity',
                                                          border:
                                                              UnderlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    controller: colorController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Color',
                                                      border:
                                                          UnderlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 200,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: selectedSize,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selectedSize =
                                                                value!;
                                                          });
                                                        },
                                                        items: size
                                                            .map((String size) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: size,
                                                            child: Center(
                                                                child:
                                                                    Text(size)),
                                                          );
                                                        }).toList(),
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Size',
                                                          border:
                                                              UnderlineInputBorder(),
                                                          alignLabelWithHint:
                                                              true,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Container(
                                                      width: 200,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: selectedCategory,
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            selectedCategory =
                                                                value!;
                                                          });
                                                        },
                                                        items: category.map(
                                                            (String category) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: category,
                                                            child:
                                                                Text(category),
                                                          );
                                                        }).toList(),
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Category',
                                                          border:
                                                              UnderlineInputBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    maxLines: 3,
                                                    maxLength: 50,
                                                    controller:
                                                        descriptionController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Description',
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15))),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(10.0)),
                              ),
                              onPressed: () {
                                addProduct();
                                Navigator.pop(context);
                              },
                              child: const Text('Confirm'),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
