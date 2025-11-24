class RequestOrder {
  final String consumerLogin;
  final String supplierLogin;
  final String inventoryType;
  final String inventoryName;

  RequestOrder({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.inventoryType,
    required this.inventoryName,
  });

  Map<String, dynamic> toJson() => {
        "consumer_login": consumerLogin,
        "supplier_login": supplierLogin,
        "inventory_type": inventoryType,
        "inventory_name": inventoryName,
      };
}

class Order {
  final String consumerLogin;
  final String supplierLogin;
  final String inventoryType;
  final String inventoryName;
  final bool isDelivered;

  Order({
    required this.consumerLogin,
    required this.supplierLogin,
    required this.inventoryType,
    required this.inventoryName,
    required this.isDelivered,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        consumerLogin: json["consumer_login"],
        supplierLogin: json["supplier_login"],
        inventoryType: json["inventory_type"],
        inventoryName: json["inventory_name"],
        isDelivered: json["is_delivered"] ?? false,
      );
}
