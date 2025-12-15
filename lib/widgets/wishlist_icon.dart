import 'package:flutter/material.dart';
import '../services/wishlist_service.dart';

class WishlistIcon extends StatefulWidget {
  final int productId;
  final double size;
  final Color? defaultColor;
  final Color? activeColor;

  const WishlistIcon({
    super.key,
    required this.productId,
    this.size = 24,
    this.defaultColor,
    this.activeColor,
  });

  @override
  State<WishlistIcon> createState() => _WishlistIconState();
}

class _WishlistIconState extends State<WishlistIcon>
    with SingleTickerProviderStateMixin {
  final WishlistService _wishlistService = WishlistService();
  bool _isInWishlist = false;
  bool _isLoading = true;
  bool _isAnimating = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Snap back quickly
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _isAnimating = false);
      }
    });
    _loadWishlistStatus();
  }

  Future<void> _loadWishlistStatus() async {
    try {
      final isInWishlist = await _wishlistService.isInWishlist(widget.productId);
      if (mounted) {
        setState(() {
          _isInWishlist = isInWishlist;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleWishlist() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newStatus = await _wishlistService.toggleWishlist(widget.productId);
      
      if (mounted) {
        setState(() {
          _isInWishlist = newStatus;
          _isLoading = false;
        });
        
        // Trigger animation when adding to wishlist (turning red)
        if (newStatus) {
          setState(() => _isAnimating = true);
          _animationController.forward();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating wishlist: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && !_isInWishlist) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleWishlist,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isAnimating ? _scaleAnimation.value : 1.0,
            child: Icon(
              _isInWishlist ? Icons.favorite : Icons.favorite_border,
              size: widget.size,
              color: _isInWishlist
                  ? (widget.activeColor ?? Colors.red)
                  : (widget.defaultColor ?? Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

