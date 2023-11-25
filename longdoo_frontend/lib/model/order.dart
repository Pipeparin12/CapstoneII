import 'package:longdoo_frontend/model/product.dart';

class Order {
  final String id;
  final String owner;
  final List<Product> products;
  final double totalPrice;
  final ShippingInformation shippingInformation;
  final PaymentInformation paymentInformation;
  final OrderStatus status;

  Order({
    required this.id,
    required this.owner,
    required this.products,
    required this.totalPrice,
    required this.shippingInformation,
    required this.paymentInformation,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      owner: json['owner'],
      products: List<Product>.from(
          json['products'].map((productJson) => Product.fromJson(productJson))),
      totalPrice: json['totalPrice'].toDouble(),
      shippingInformation:
          ShippingInformation.fromJson(json['shippingInformation']),
      paymentInformation:
          PaymentInformation.fromJson(json['paymentInformation']),
      status: OrderStatus.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner': owner,
      'products':
          List<dynamic>.from(products.map((product) => product.toJson())),
      'totalPrice': totalPrice,
      'shippingInformation': shippingInformation.toJson(),
      'paymentInformation': paymentInformation.toJson(),
      'status': status.toJson(),
    };
  }
}

class ShippingInformation {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;

  ShippingInformation({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
  });

  factory ShippingInformation.fromJson(Map<String, dynamic> json) {
    return ShippingInformation(
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
    };
  }
}

class PaymentInformation {
  final String slip;

  PaymentInformation({
    required this.slip,
  });

  factory PaymentInformation.fromJson(Map<String, dynamic> json) {
    return PaymentInformation(
      slip: json['slip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slip': slip,
    };
  }
}

class OrderStatus {
  final String status;
  final String description;

  OrderStatus({
    required this.status,
    required this.description,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      status: json['status'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
    };
  }
}
