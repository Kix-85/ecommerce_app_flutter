import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/product.dart';
import 'product_card.dart';

class ProductMasonryGrid extends StatelessWidget {
  final List<Product> products;

  const ProductMasonryGrid({
    super.key, 
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 100), // Bottom padding for Nav Bar
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
        );
      },
    );
  }
}
