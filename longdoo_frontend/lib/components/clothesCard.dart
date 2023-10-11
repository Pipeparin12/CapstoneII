import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:longdoo_frontend/model/clothes.dart';

import '../screen/accountName/accName.dart';

class ClothesCard extends StatelessWidget {
  final ClothingItem demoClothes;
  final GestureTapCallback press;
  const ClothesCard({Key? key, required this.demoClothes, required this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: press,
          // () {
          //   // Navigate to the item detail screen when an item is tapped.
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => AccNameScreen(),
          //     ),
          //   );
          // },
          child: Column(
            children: [
              Card(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(demoClothes.imagePath),
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
                demoClothes.price.toStringAsFixed(0) + " ฿",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                demoClothes.name,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.left,
              ),
            ],
          )),
    );
  }
}
