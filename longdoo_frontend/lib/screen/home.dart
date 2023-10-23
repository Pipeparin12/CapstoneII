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
    {
      'name': 'Sale',
      'category': 'Sale',
      'productImage': 'assets/images/sale.png',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LongDoo',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
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
    );
  }
}
