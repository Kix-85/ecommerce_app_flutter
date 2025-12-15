class CartItem {
  final int id;
  final int? custId; // Schema allows null in cart? "cust_id integer". But logically should be there.
  final int? productId;
  final int? quantity;
  final Map<String, dynamic>? product; 

  CartItem({
    required this.id,
    this.custId,
    this.productId,
    this.quantity,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['cart_id'] as int,
      custId: json['cust_id'] as int?,
      productId: json['product_id'] as int?,
      quantity: json['quantity'] as int?,
      product: json['products'] as Map<String, dynamic>?,
    );
  }
}
