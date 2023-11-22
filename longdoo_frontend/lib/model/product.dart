class Product {
  final String id;
  final String productName;
  final double price;
  final double quantity;
  final String color;
  final String category;
  final String productDescription;
  final String productImage;

  Product.set({
    required this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.color,
    required this.category,
    required this.productDescription,
    required this.productImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product.set(
        id: json['_id'],
        productName: json['productName'],
        price: json['price'],
        quantity: json['quatity'],
        color: json['color'],
        category: json['category'],
        productDescription: json['productDescription'],
        productImage: json['productImage']);
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'color': color,
      'category': category,
      'productDescription': productDescription,
      'productImage': productImage
    };
  }
}
