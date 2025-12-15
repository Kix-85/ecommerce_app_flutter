import 'package:flutter/material.dart';
import '../widgets/product_details/product_image_header.dart';
import '../widgets/product_details/product_info_section.dart';
import '../widgets/product_details/product_description.dart';
import '../widgets/product_details/selection_section.dart';
import '../widgets/product_details/add_to_cart_bottom_bar.dart';

import '../models/product.dart';
import '../services/cart_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Helper for oldPrice (dummy logic for now)
  String get _oldPrice => widget.product != null ? '\$${(widget.product!.price * 1.2).toStringAsFixed(2)}' : '';
  
  void _addToCart() async {
    if (widget.product == null) return;
    try {
      await CartService().addToCart(widget.product!.id, 1); // Default qty 1
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
             Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProductImageHeader(),
                      const SizedBox(height: 20),
                      ProductInfoSection(
                        title: product?.name ?? 'Loading...',
                        rating: '5.0',
                        reviewCount: '120 reviews',
                      ),
                      const SizedBox(height: 20),
                      const ProductDescription(
                        description:
                            'This is a premium product. High quality and comfortable to wear.',
                      ),
                      const SizedBox(height: 20),
                      const SelectionSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
             AddToCartBottomBar(
              price: product != null ? '\$${product.price}' : '',
              oldPrice: _oldPrice,
              onTap: _addToCart,
            ),
          ],
        ),
      ),
    );
  }
}
