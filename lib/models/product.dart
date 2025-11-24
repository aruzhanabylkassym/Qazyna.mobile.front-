class Product {
  final String id;
  final String name;
  final String supplierLogin;
  final String supplierName;
  final double price;
  final String unit;
  final int minOrderQuantity;
  final String? description;
  final String? imageUrl;
  final List<String> tags;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.supplierLogin,
    required this.supplierName,
    required this.price,
    required this.unit,
    required this.minOrderQuantity,
    this.description,
    this.imageUrl,
    this.tags = const [],
    this.inStock = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"]?.toString() ?? json["inventory_name"]?.toString() ?? "",
        name: json["name"] ?? json["inventory_name"] ?? "",
        supplierLogin: json["supplier_login"] ?? "",
        supplierName: json["supplier_name"] ?? "",
        price: (json["price"] ?? 0.0).toDouble(),
        unit: json["unit"] ?? "",
        minOrderQuantity: json["min_order_quantity"] ?? json["moq"] ?? 1,
        description: json["description"],
        imageUrl: json["image_url"],
        tags: json["tags"] != null ? List<String>.from(json["tags"]) : [],
        inStock: json["in_stock"] ?? true,
      );
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

