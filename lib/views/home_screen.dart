import 'package:flutter/material.dart';
import '../widgets/search_bar_section.dart';
import '../widgets/category_selector.dart';
import '../widgets/product_masonry_grid.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../core/supabase_config.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;
  
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;

  // Map index to category names in DB
  final List<String> _categories = [
    'All',
    'Dresses',
    'Shirts',
    'Pants', 
  ];

  String _customerName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCustomerName();
  }

  Future<void> _fetchCustomerName() async {
    final custId = AuthService.currentCustomerId;
    if (custId == null) return;
    
    try {
      final response = await SupabaseConfig.client
          .from('customers')
          .select('f_name, l_name')
          .eq('cust_id', custId)
          .single();
      
      final fName = response['f_name'] as String? ?? '';
      final lName = response['l_name'] as String? ?? '';
      
      if (mounted) {
        setState(() {
          _customerName = '$fName $lName'.trim();
          if (_customerName.isEmpty) _customerName = 'User';
        });
      }
    } catch (e) {
      // Ignore or log
    }
  }

  void _fetchProducts() {
    setState(() {
      if (_searchQuery.isNotEmpty) {
        _productsFuture = _productService.searchProducts(_searchQuery);
      } else if (_selectedCategoryIndex > 0) {
        // Index 0 is All
        final category = _categories[_selectedCategoryIndex];
        _productsFuture = _productService.getProductsByCategory(category);
      } else {
        _productsFuture = _productService.getProducts();
      }
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _fetchProducts(); // Debounce could be added here for better perf
  }

  void _onCategorySelected(int index) {
    _selectedCategoryIndex = index;
    _searchQuery = ''; 
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Custom Top Bar with Welcome Text and Avatar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            _customerName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFE0E0E0), 
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                
                SearchBarSection(
                  onSearchChanged: _onSearchChanged,
                ),
                
                CategorySelector(
                  selectedIndex: _selectedCategoryIndex,
                  onCategorySelected: _onCategorySelected,
                ),
                
                const SizedBox(height: 20),
                
                Expanded(
                  child: FutureBuilder<List<Product>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found'));
                      }
                      
                      return ProductMasonryGrid(
                        products: snapshot.data!,
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Floating Bottom Navigation Bar
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: CustomBottomNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
