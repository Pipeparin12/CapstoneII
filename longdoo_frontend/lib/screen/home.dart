import 'package:flutter/material.dart';
import 'package:longdoo_frontend/screen/category.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _listItems = [
    {
      'name': 'Men\'s Wear',
      'category': 'Men',
      'productImage': 'assets/images/menswear.jpg',
    },
    {
      'name': 'Women\'s Wear',
      'category': 'Women',
      'productImage': 'assets/images/womenswear.jpg',
    },
    {
      'name': 'Kids Wear',
      'category': 'Kids',
      'productImage': 'assets/images/kidswear.jpg',
    },
    {
      'name': 'Unisex',
      'category': 'Unisex',
      'productImage': 'assets/images/unisex.png',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'LongDoo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 370,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: AssetImage('assets/images/sale.png'),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        child: Container(
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                name: 'Sale',
                                category: 'Sale',
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  children: _listItems
                      .where((item) =>
                          _searchQuery.isEmpty ||
                          item['name']
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            // Navigate to the item detail screen when an item is tapped.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                  name: item['name'],
                                  category: item['category'],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: AssetImage(item['productImage']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Transform.translate(
                                    offset: Offset(30, -30),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 65,
                                        vertical: 63,
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
                                item['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
