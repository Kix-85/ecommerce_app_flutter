class Product {
  final int id;
  final String name;
  final num price;
  final String category;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stockQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'] as int,
      name: json['product_name'] as String,
      price: json['product_price'] as num,
      category: json['category_name'] as String,
      stockQuantity: json['stock_quantity'] as int,
    );
  }
}
