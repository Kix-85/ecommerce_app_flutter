import 'package:flutter/material.dart';
import '../views/cart_screen.dart';
import '../views/order_history_screen.dart';
import '../views/profile_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F22),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home_filled, isActive: true),
          _buildNavItem(context, Icons.shopping_bag_outlined, badge: true, isCart: true),
          _buildNavItem(context, Icons.favorite_border),
          _buildNavItem(context, Icons.person_outline, isProfile: true),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, {bool isActive = false, bool badge = false, bool isCart = false, bool isProfile = false}) {
    return GestureDetector(
      onTap: () {
        if (isCart) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        } else if (isProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey,
                size: 28,
              ),
              if (badge)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
