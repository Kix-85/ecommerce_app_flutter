import '../core/supabase_config.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'auth_service.dart';

class CartService {
  int get _currentCustId {
    final id = AuthService.currentCustomerId;
    if (id == null) {
      throw Exception('Customer ID not loaded');
    }
    return id;
  }

  Future<List<CartItem>> getCartItems() async {
    final response = await SupabaseConfig.client
        .from('cart')
        .select('*, products(*)') // Join with products table
        .eq('cust_id', _currentCustId);

    final data = response as List<dynamic>;
    return data.map((json) => CartItem.fromJson(json)).toList();
  }

  Future<void> addToCart(int productId, int quantity) async {
    // Check if item already exists
    final existing = await SupabaseConfig.client
        .from('cart')
        .select()
        .eq('cust_id', _currentCustId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      // Update quantity
      final newQuantity = (existing['quantity'] as int) + quantity;
      await SupabaseConfig.client
          .from('cart')
          .update({'quantity': newQuantity})
          .eq('cart_id', existing['cart_id']);
    } else {
      // Insert new
      await SupabaseConfig.client.from('cart').insert({
        'cust_id': _currentCustId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
  }

  Future<void> updateQuantity(int cartId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(cartId);
    } else {
      await SupabaseConfig.client
          .from('cart')
          .update({'quantity': quantity})
          .eq('cart_id', cartId);
    }
  }

  Future<void> checkout() async {
    // 1. Get current cart items
    final cartItems = await getCartItems();
    if (cartItems.isEmpty) return;

    // 2. Calculate totals
    double totalAmount = 0;
    int totalQuantity = 0;
    for (var item in cartItems) {
      final price = (item.product?['product_price'] as num? ?? 0).toDouble();
      totalAmount += price * (item.quantity ?? 0);
      totalQuantity += (item.quantity ?? 0);
    }

    // IDs
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final orderNo = 'ORD-$timestamp';
    final payNo = 'PAY-$timestamp';
    final trackingNo = timestamp % 2147483647; // Ensure fits in PG Integer

    try {
      // 3. Insert Tracking (Required by Order FK)
      await SupabaseConfig.client.from('tracking_detail').insert({
        'tracking_no': trackingNo,
        'courier_name': 'Standard Delivery',
      });

      // 4. Insert Order
      await SupabaseConfig.client.from('orders').insert({
        'order_no': orderNo,
        'order_date': DateTime.now().toIso8601String(),
        'quantity': totalQuantity,
        'order_amount': totalAmount.toInt(), // Schema says integer
        'order_name': 'Order #$timestamp',
        'order_details': 'Order of $totalQuantity items',
        'discount': 0.0,
        'cust_id': _currentCustId,
        'tracking_no': trackingNo,
      });

      // 5. Insert Order Items
      for (var item in cartItems) {
        final price = (item.product?['product_price'] as num? ?? 0).toDouble();
        await SupabaseConfig.client.from('order_items').insert({
          'order_no': orderNo,
          'product_id': item.productId,
          'quantity': item.quantity,
          'unit_price': price,
        });
      }

      // 6. Insert Payment
      await SupabaseConfig.client.from('payment').insert({
        'pay_no': payNo,
        'pay_amount': totalAmount,
        'pay_date': DateTime.now().toIso8601String(),
        'cust_id': _currentCustId,
      });

      // 7. Clear Cart
      await SupabaseConfig.client
          .from('cart')
          .delete()
          .eq('cust_id', _currentCustId);
          
    } catch (e) {
      // In a real app, strict error handling/rollback needed here.
      // For MVP/Demo, just rethrow or log.
      print('Checkout error: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(int cartId) async {
    await SupabaseConfig.client.from('cart').delete().eq('cart_id', cartId);
  }

  Future<List<Order>> getOrders() async {
    final response = await SupabaseConfig.client
        .from('orders')
        .select()
        .eq('cust_id', _currentCustId)
        .order('order_date', ascending: false);

    final data = response as List<dynamic>;
    return data.map((json) => Order.fromJson(json)).toList();
  }
}
