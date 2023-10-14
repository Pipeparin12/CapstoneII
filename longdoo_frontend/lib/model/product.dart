class Product {
  final int id;
  final String productName;
  final double price;
  final double quantity;
  final String color;
  final String category;
  final String productDescription;
  final String productImage;

  Product({
    required this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.color,
    required this.category,
    required this.productDescription,
    required this.productImage,
  });
}

List<Product> demoProduct = [
  Product(
    id: 1,
    productName: "Men's Casual Shirt",
    price: 890,
    color: 'Blue',
    category: 'Women',
    quantity: 2,
    productDescription: 'A comfortable and stylish shirt for casual occasions.',
    productImage: 'assets/images/two.jpg',
  ),
  Product(
    id: 2,
    productName: 'Elegant Evening Dress',
    price: 590,
    category: 'Women',
    quantity: 3,
    color: 'Black',
    productDescription: 'An elegant dress for special evening events.',
    productImage: 'assets/images/three.jpg',
  ),
  Product(
    id: 3,
    productName: 'Slim Fit Jeans',
    price: 1099,
    quantity: 10,
    category: 'Women',
    color: 'Dark Blue',
    productDescription: 'Slim fit jeans for a modern look and comfort.',
    productImage: 'assets/images/four.jpg',
  ),
  Product(
    id: 4,
    productName: 'Slim Fit Jeans',
    price: 1099,
    quantity: 10,
    category: 'Women',
    color: 'Dark Blue',
    productDescription: 'Slim fit jeans for a modern look and comfort.',
    productImage: 'assets/images/four.jpg',
  ),
];
