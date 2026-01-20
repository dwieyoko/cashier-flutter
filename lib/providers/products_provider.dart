import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/product.dart';
import '../data/local/hive_service.dart';

/// Provider for the products list
final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});

/// Provider for filtered products by category
final filteredProductsProvider = Provider.family<List<Product>, String>((ref, category) {
  final products = ref.watch(productsProvider);
  if (category == 'All') {
    return products;
  }
  return products.where((p) => p.category == category).toList();
});

/// Provider for searching products
final productSearchProvider = Provider.family<List<Product>, String>((ref, query) {
  final products = ref.watch(productsProvider);
  if (query.isEmpty) {
    return products;
  }
  final lowerQuery = query.toLowerCase();
  return products.where((p) => 
    p.name.toLowerCase().contains(lowerQuery) ||
    (p.barcode?.toLowerCase().contains(lowerQuery) ?? false)
  ).toList();
});

/// Provider to find product by barcode
final productByBarcodeProvider = Provider.family<Product?, String>((ref, barcode) {
  final products = ref.watch(productsProvider);
  try {
    return products.firstWhere((p) => p.barcode == barcode);
  } catch (_) {
    return null;
  }
});

class ProductsNotifier extends StateNotifier<List<Product>> {
  final _uuid = const Uuid();
  
  ProductsNotifier() : super([]) {
    _loadProducts();
  }
  
  /// Load products from local storage
  void _loadProducts() {
    final box = HiveService.getProductsBox();
    state = box.values.toList();
    
    // Add sample products if empty
    if (state.isEmpty) {
      _addSampleProducts();
    }
  }
  
  /// Add sample products for demo
  void _addSampleProducts() {
    final sampleProducts = [
      Product(
        id: _uuid.v4(),
        name: 'Coffee Latte',
        description: 'Fresh brewed coffee with milk',
        price: 4.99,
        barcode: '1234567890123',
        category: 'Drinks',
        stockQuantity: 100,
        createdAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Croissant',
        description: 'Buttery French pastry',
        price: 3.49,
        barcode: '1234567890124',
        category: 'Food',
        stockQuantity: 50,
        createdAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Chocolate Chip Cookie',
        description: 'Freshly baked cookie',
        price: 2.49,
        barcode: '1234567890125',
        category: 'Snacks',
        stockQuantity: 75,
        createdAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Bottled Water',
        description: '500ml spring water',
        price: 1.99,
        barcode: '1234567890126',
        category: 'Drinks',
        stockQuantity: 200,
        createdAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Sandwich',
        description: 'Ham and cheese sandwich',
        price: 6.99,
        barcode: '1234567890127',
        category: 'Food',
        stockQuantity: 30,
        createdAt: DateTime.now(),
      ),
      Product(
        id: _uuid.v4(),
        name: 'Energy Drink',
        description: 'Boost your energy',
        price: 3.99,
        barcode: '1234567890128',
        category: 'Drinks',
        stockQuantity: 60,
        createdAt: DateTime.now(),
      ),
    ];
    
    for (final product in sampleProducts) {
      addProduct(product);
    }
  }
  
  /// Add a new product
  void addProduct(Product product) {
    final box = HiveService.getProductsBox();
    box.put(product.id, product);
    state = [...state, product];
  }
  
  /// Update an existing product
  void updateProduct(Product product) {
    final box = HiveService.getProductsBox();
    box.put(product.id, product);
    state = state.map((p) => p.id == product.id ? product : p).toList();
  }
  
  /// Delete a product
  void deleteProduct(String id) {
    final box = HiveService.getProductsBox();
    box.delete(id);
    state = state.where((p) => p.id != id).toList();
  }
  
  /// Create a new product with generated ID
  Product createProduct({
    required String name,
    String? description,
    required double price,
    String? barcode,
    String? imageUrl,
    required String category,
    int stockQuantity = 0,
  }) {
    final product = Product(
      id: _uuid.v4(),
      name: name,
      description: description,
      price: price,
      barcode: barcode,
      imageUrl: imageUrl,
      category: category,
      stockQuantity: stockQuantity,
      createdAt: DateTime.now(),
    );
    addProduct(product);
    return product;
  }
}
