import 'package:flutter/material.dart';
import 'package:longdoo_frontend/components/wishlistCard.dart';

import 'package:longdoo_frontend/model/product.dart';

import 'package:longdoo_frontend/screen/cart.dart';
import 'package:longdoo_frontend/screen/itemDetail.dart';
import 'package:longdoo_frontend/screen/order/processing.dart';
import 'package:longdoo_frontend/screen/order/shipped.dart';
import 'package:longdoo_frontend/screen/order/unpaid.dart';
import 'package:longdoo_frontend/screen/support.dart';

import '../components/clothesCard.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Hi, Jannette',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Informations & Services',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.emoji_people,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Your Size',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SupportScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.support_agent,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Support',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccountScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.manage_accounts,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Account',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'My Orders',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UnpaidScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.account_balance_wallet,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Unpaid',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProcessingScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.pallet,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Processing',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShippedScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.local_shipping,
                                size: 35,
                              ),
                            ),
                            Text(
                              'Shipped',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 5, left: 5, bottom: 10),
            height: 280,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Wishlist',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 0,
                              children: [
                            ...List.generate(
                                demoProduct.length,
                                (index) => WishlistCard(
                                    demoProduct: demoProduct[index],
                                    press: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemDetailScreen(
                                              demoItem: demoProduct[index],
                                            ),
                                          ),
                                        )))
                          ]))
                    ])),
          )
        ],
      ),
    );
  }
}
