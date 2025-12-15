import 'package:flutter/material.dart';

class ProductImageHeader extends StatelessWidget {
  const ProductImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(
            child: Icon(Icons.image, size: 100, color: Colors.grey),
          ),
        ),
        Positioned(
          top: 20, // SafeArea padding usually handled by parent or here
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
