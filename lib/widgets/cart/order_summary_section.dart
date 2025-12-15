import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;

  const OrderSummarySection({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 15),
        _buildSummaryRow(label: 'Shipping', value: '\$${shipping.toStringAsFixed(2)}'),
        const SizedBox(height: 15),
        // Discount could be added here if needed
        _buildSummaryRow(label: 'Total', value: '\$${total.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow({required String label, required String value, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
