import 'package:flutter/material.dart';
import '../views/cart_screen.dart';
import '../views/order_history_screen.dart';
import '../views/profile_screen.dart';
import '../views/wishlist_screen.dart';
import '../views/home_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  // Helper to check if current route matches a screen name
  bool _isCurrentRoute(BuildContext context, String routeName) {
    final route = ModalRoute.of(context);
    return route?.settings.name == routeName;
  }

  @override
  Widget build(BuildContext context) {
    // Determine which screen is active
    // Home is active if we're at root (can't pop)
    final isHome = !Navigator.of(context).canPop() || 
                  _isCurrentRoute(context, '/') ||
                  _isCurrentRoute(context, '/home');
    final isWishlist = _isCurrentRoute(context, '/wishlist');
    final isCart = _isCurrentRoute(context, '/cart');
    final isProfile = _isCurrentRoute(context, '/profile');

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
          _buildNavItem(context, Icons.home_filled, isActive: isHome, isHome: true),
          _buildNavItem(context, Icons.shopping_bag_outlined, badge: true, isActive: isCart, isCart: true),
          _buildNavItem(context, Icons.favorite_border, isActive: isWishlist, isWishlist: true),
          _buildNavItem(context, Icons.person_outline, isActive: isProfile, isProfile: true),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, {bool isActive = false, bool badge = false, bool isCart = false, bool isProfile = false, bool isWishlist = false, bool isHome = false}) {
    return GestureDetector(
      onTap: () {
        if (isHome) {
          // Navigate to home - pop until we reach root
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        } else if (isCart) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CartScreen(),
              settings: const RouteSettings(name: '/cart'),
            ),
          );
        } else if (isProfile) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
              settings: const RouteSettings(name: '/profile'),
            ),
          );
        } else if (isWishlist) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WishlistScreen(),
              settings: const RouteSettings(name: '/wishlist'),
            ),
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
