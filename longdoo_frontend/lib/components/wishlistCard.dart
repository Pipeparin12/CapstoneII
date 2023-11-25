import 'package:flutter/material.dart';
import 'package:longdoo_frontend/model/product.dart';

class WishlistCard extends StatelessWidget {
  final Product demoProduct;
  final GestureTapCallback press;
  const WishlistCard({required this.demoProduct, required this.press});

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
                    offset: const Offset(50, -50),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 65,
                        vertical: 60,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.bookmark_border,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
