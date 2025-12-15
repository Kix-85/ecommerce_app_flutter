import 'package:flutter/material.dart';
import '../../widgets/wishlist_icon.dart';

class ProductInfoSection extends StatefulWidget {
  final String title;
  final String rating;
  final String reviewCount;
  final int? productId;

  const ProductInfoSection({
    super.key,
    required this.title,
    required this.rating,
    required this.reviewCount,
    this.productId,
  });

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (widget.productId != null) ...[
                    const SizedBox(width: 10),
                    WishlistIcon(
                      productId: widget.productId!,
                      size: 28,
                    ),
                  ],
                ],
              ),
            ),
            Row(
              children: [
                _buildQuantityButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (quantity > 1) setState(() => quantity--);
                  },
                ),
                const SizedBox(width: 15),
                Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15),
                _buildQuantityButton(
                  icon: Icons.add,
                  onTap: () => setState(() => quantity++),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600], size: 20),
            const SizedBox(width: 5),
            Text(
              widget.rating,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '(${widget.reviewCount})',
              style: const TextStyle(
                color: Colors.blue, // As per design roughly or theme
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
