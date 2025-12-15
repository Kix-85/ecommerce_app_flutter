import '../core/supabase_config.dart';

class SeedingService {
  Future<void> seedProducts() async {
    // 1. Check if products already exist
    final response = await SupabaseConfig.client
        .from('products')
        .select('*')
        .limit(1);

    if ((response as List).isNotEmpty) {
      print('Products already seeded. Skipping.');
      return;
    }

    print('Seeding products...');

    // 2. Define mock products
    final List<Map<String, dynamic>> products = [
      {
        'product_name': 'Classic White Shirt',
        'category_name': 'Shirts',
        'product_price': 29.99,
        'stock_quantity': 50,
        // 'image_url': '...' // Add if schema has it
      },
      {
        'product_name': 'Denim Blue Jeans',
        'category_name': 'Pants',
        'product_price': 49.99,
        'stock_quantity': 40,
      },
      {
        'product_name': 'Floral Summer Dress',
        'category_name': 'Dresses',
        'product_price': 59.99,
        'stock_quantity': 30,
      },
      {
        'product_name': 'Leather Jacket',
        'category_name': 'Jackets', // Note: CategorySelector doesn't have Jacket icon but "All" will show it
        'product_price': 129.99,
        'stock_quantity': 15,
      },
      {
        'product_name': 'Running Shoes',
        'category_name': 'Shoes',
        'product_price': 89.99,
        'stock_quantity': 25,
      },
      {
        'product_name': 'Casual T-Shirt',
        'category_name': 'Shirts',
        'product_price': 19.99,
        'stock_quantity': 100,
      },
      {
        'product_name': 'Formal Trousers',
        'category_name': 'Pants',
        'product_price': 69.99,
        'stock_quantity': 35,
      },
      {
        'product_name': 'Evening Gown',
        'category_name': 'Dresses',
        'product_price': 199.99,
        'stock_quantity': 10,
      },
    ];

    // 3. Insert products
    await SupabaseConfig.client.from('products').insert(products);
    print('Products seeded successfully.');
  }
}
