class Order {
  final String orderNo;
  final DateTime? orderDate;
  final int? quantity;
  final int? orderAmount; // Schema says int for amount? "order_amount integer"
  final String? orderName;
  final String? orderDetails;
  final double? discount;
  final int? custId;
  final int? trackingNo;

  Order({
    required this.orderNo,
    this.orderDate,
    this.quantity,
    this.orderAmount,
    this.orderName,
    this.orderDetails,
    this.discount,
    this.custId,
    this.trackingNo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNo: json['order_no'] as String,
      orderDate: json['order_date'] != null ? DateTime.tryParse(json['order_date']) : null,
      quantity: json['quantity'] as int?,
      orderAmount: json['order_amount'] as int?,
      orderName: json['order_name'] as String?,
      orderDetails: json['order_details'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      custId: json['cust_id'] as int?,
      trackingNo: json['tracking_no'] as int?,
    );
  }
}
