class ClothingItem {
  final int id;
  final String name;
  final double price;
  final double amount;
  final String color;
  final String category;
  final String description;
  final String imagePath;

  ClothingItem({
    required this.id,
    required this.name,
    required this.price,
    required this.amount,
    required this.color,
    required this.category,
    required this.description,
    required this.imagePath,
  });
}

List<ClothingItem> demoClothes = [
  ClothingItem(
    id: 1,
    name: "Men's Casual Shirt",
    price: 890,
    color: 'Blue',
    category: 'Women',
    amount: 2,
    description: 'A comfortable and stylish shirt for casual occasions.',
    imagePath: 'assets/images/two.jpg',
  ),
  ClothingItem(
    id: 2,
    name: 'Elegant Evening Dress',
    price: 590,
    category: 'Women',
    amount: 3,
    color: 'Black',
    description: 'An elegant dress for special evening events.',
    imagePath: 'assets/images/three.jpg',
  ),
  ClothingItem(
    id: 3,
    name: 'Slim Fit Jeans',
    price: 1099,
    amount: 10,
    category: 'Women',
    color: 'Dark Blue',
    description: 'Slim fit jeans for a modern look and comfort.',
    imagePath: 'assets/images/four.jpg',
  ),
  ClothingItem(
    id: 4,
    name: 'Slim Fit Jeans',
    price: 1099,
    amount: 10,
    category: 'Women',
    color: 'Dark Blue',
    description: 'Slim fit jeans for a modern look and comfort.',
    imagePath: 'assets/images/four.jpg',
  ),
];
