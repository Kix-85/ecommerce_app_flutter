class OrderItem {
  final String orderNo;
  final int productId;
  final int? quantity;
  final double? unitPrice;

  OrderItem({
    required this.orderNo,
    required this.productId,
    this.quantity,
    this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderNo: json['order_no'] as String,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_no': orderNo,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}
