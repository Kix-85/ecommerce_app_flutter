import 'package:flutter/material.dart';
import '../widgets/cart/cart_item.dart';
import '../widgets/cart/payment_method_section.dart';
import '../widgets/cart/order_summary_section.dart';
import '../widgets/cart/checkout_button.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final items = await _cartService.getCartItems();
      setState(() {
        _cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error loading cart: $e')),
        );
      }
    }
  }

  Future<void> _updateQuantity(int cartId, int newQuantity) async {
    // Optimistic update
    final index = _cartItems.indexWhere((item) => item.id == cartId);
    if (index == -1) return;

    final oldQuantity = _cartItems[index].quantity;
    
    // Update local state temporarily (optional, but good for UX) or just wait for refresh
    // Here we'll just wait for the API and reload for simplicity in MVP
    
    try {
      await _cartService.updateQuantity(cartId, newQuantity);
      await _loadCart();
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error updating cart: $e')),
        );
      }
    }
  }

  double get _subtotal {
    return _cartItems.fold(0, (sum, item) {
       final price = item.product != null ? (item.product!['product_price'] as num).toDouble() : 0.0;
       return sum + (price * (item.quantity ?? 1));
    });
  }

  double get _shipping => 10.0; // Flat rate for now

  double get _total => _subtotal + _shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
        ),
        centerTitle: true,
        title: Container(
          height: 8,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              child: Icon(Icons.sort),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ..._cartItems.map((item) => CartItemWidget(
                            item: item,
                            onIncrease: () => _updateQuantity(item.id, (item.quantity ?? 1) + 1),
                            onDecrease: () => _updateQuantity(item.id, (item.quantity ?? 1) - 1),
                          )),
                      const SizedBox(height: 20),
                      Container(
                        height: 4,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const PaymentMethodSection(),
                      const SizedBox(height: 30),
                      OrderSummarySection(
                        subtotal: _subtotal,
                        shipping: _shipping,
                        total: _total,
                      ),
                      const SizedBox(height: 30),
                      CheckoutButton(
                        onTap: _checkout,
                      ),
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
    );
  }

  Future<void> _checkout() async {
    setState(() => _isLoading = true);
    try {
      await _cartService.checkout();
      if (mounted) {
        setState(() {
            _cartItems.clear(); // Clear local list
            _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Checkout failed: $e')),
        );
      }
    }
  }
}
