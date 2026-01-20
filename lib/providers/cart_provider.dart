import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';

/// Provider for the shopping cart
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

/// Provider for cart item count
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

/// Provider for cart subtotal
final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.subtotal);
});

/// Provider for cart tax (uses store config tax rate)
final cartTaxProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  // Default 10% tax - this will be updated to use store config
  return subtotal * 0.10;
});

/// Provider for cart total
final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final tax = ref.watch(cartTaxProvider);
  return subtotal + tax;
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);
  
  /// Add product to cart or increment quantity if exists
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      // Product exists, update quantity
      final updatedItems = [...state];
      updatedItems[existingIndex] = CartItem(
        product: product,
        quantity: state[existingIndex].quantity + quantity,
      );
      state = updatedItems;
    } else {
      // New product
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }
  
  /// Remove item from cart
  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }
  
  /// Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    state = state.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: quantity);
      }
      return item;
    }).toList();
  }
  
  /// Increment item quantity
  void incrementQuantity(String productId) {
    state = state.map((item) {
      if (item.product.id == productId) {
        return CartItem(product: item.product, quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }
  
  /// Decrement item quantity
  void decrementQuantity(String productId) {
    final item = state.firstWhere((i) => i.product.id == productId);
    if (item.quantity <= 1) {
      removeFromCart(productId);
    } else {
      state = state.map((item) {
        if (item.product.id == productId) {
          return CartItem(product: item.product, quantity: item.quantity - 1);
        }
        return item;
      }).toList();
    }
  }
  
  /// Clear entire cart
  void clearCart() {
    state = [];
  }
  
  /// Check if product is in cart
  bool isInCart(String productId) {
    return state.any((item) => item.product.id == productId);
  }
  
  /// Get quantity of product in cart
  int getQuantity(String productId) {
    try {
      return state.firstWhere((item) => item.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }
}
