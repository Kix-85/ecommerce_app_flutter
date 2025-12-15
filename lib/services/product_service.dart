import '../core/supabase_config.dart';
import '../models/product.dart';
import 'auth_service.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    final response = await SupabaseConfig.client
        .from('products')
        .select()
        .order('product_id', ascending: true);

    final data = response as List<dynamic>;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final response = await SupabaseConfig.client
        .from('products')
        .select()
        .eq('product_id', id)
        .single();
    
    return Product.fromJson(response);
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await SupabaseConfig.client
        .from('products')
        .select()
        .ilike('product_name', '%$query%')
        .order('product_id', ascending: true);

    final data = response as List<dynamic>;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await SupabaseConfig.client
        .from('products')
        .select()
        .eq('category_name', category)
        .order('product_id', ascending: true);

    final data = response as List<dynamic>;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  // Favorites functionality removed
}
