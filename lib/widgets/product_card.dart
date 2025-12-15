import 'package:flutter/material.dart';
import '../models/product.dart';
import '../views/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color backgroundColor;

  const ProductCard({
    super.key,
    required this.product,
    this.backgroundColor = const Color(0xFFF3F3F3),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
        );
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200, 
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Image placeholder
              const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              '\$${product.price}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(Icons.star, size: 16, color: Colors.amber[600]),
            const SizedBox(width: 4),
            Text(
              '5.0', // Hardcoded rating as it's not in Product model yet
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
      ),
    );
  }
}
