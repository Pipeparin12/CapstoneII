import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:longdoo_frontend/model/product.dart';

import '../screen/accountName/accName.dart';

class ClothesCard extends StatelessWidget {
  final Product demoProduct;
  final GestureTapCallback press;
  const ClothesCard({Key? key, required this.demoProduct, required this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: press,
          child: Column(
            children: [
              Card(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(demoProduct.productImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Transform.translate(
                    offset: Offset(50, -50),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 65,
                        vertical: 60,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                demoProduct.price.toStringAsFixed(0) + " ฿",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                demoProduct.productName,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.left,
              ),
            ],
          )),
    );
  }
}
