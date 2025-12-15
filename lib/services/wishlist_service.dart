import '../core/supabase_config.dart';
import '../models/product.dart';
import 'auth_service.dart';

class WishlistService {
  int get _currentCustId {
    final id = AuthService.currentCustomerId;
    if (id == null) {
      throw Exception('Customer ID not loaded');
    }
    return id;
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(int productId) async {
    try {
      final response = await SupabaseConfig.client
          .from('wishlist')
          .select()
          .eq('cust_id', _currentCustId)
          .eq('product_id', productId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('Error checking wishlist: $e');
      return false;
    }
  }

  // Add product to wishlist
  Future<void> addToWishlist(int productId) async {
    try {
      // Check if already exists
      final existing = await SupabaseConfig.client
          .from('wishlist')
          .select()
          .eq('cust_id', _currentCustId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing == null) {
        await SupabaseConfig.client.from('wishlist').insert({
          'cust_id': _currentCustId,
          'product_id': productId,
        });
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(int productId) async {
    try {
      await SupabaseConfig.client
          .from('wishlist')
          .delete()
          .eq('cust_id', _currentCustId)
          .eq('product_id', productId);
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }

  // Toggle wishlist status
  Future<bool> toggleWishlist(int productId) async {
    final isInWishlist = await this.isInWishlist(productId);
    if (isInWishlist) {
      await removeFromWishlist(productId);
      return false;
    } else {
      await addToWishlist(productId);
      return true;
    }
  }

  // Get all wishlist product IDs
  Future<List<int>> getWishlistProductIds() async {
    try {
      final response = await SupabaseConfig.client
          .from('wishlist')
          .select('product_id')
          .eq('cust_id', _currentCustId);

      final data = response as List<dynamic>;
      return data.map((json) => json['product_id'] as int).toList();
    } catch (e) {
      print('Error getting wishlist: $e');
      return [];
    }
  }

  // Get all wishlist products with full product data
  Future<List<Product>> getWishlistProducts() async {
    try {
      final response = await SupabaseConfig.client
          .from('wishlist')
          .select('products(*)')
          .eq('cust_id', _currentCustId);

      final data = response as List<dynamic>;
      return data
          .map((json) {
            final productData = json['products'];
            if (productData != null) {
              return Product.fromJson(productData);
            }
            return null;
          })
          .whereType<Product>()
          .toList();
    } catch (e) {
      print('Error getting wishlist products: $e');
      return [];
    }
  }
}

