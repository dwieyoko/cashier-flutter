import 'product.dart';

/// Represents an item in the shopping cart
class CartItem {
  final Product product;
  int quantity;
  
  CartItem({
    required this.product,
    this.quantity = 1,
  });
  
  /// Calculate subtotal for this item
  double get subtotal => product.price * quantity;
  
  /// Increment quantity
  void increment() {
    quantity++;
  }
  
  /// Decrement quantity (minimum 1)
  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
  
  /// Create a copy with updated quantity
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
  
  @override
  String toString() {
    return 'CartItem(product: ${product.name}, quantity: $quantity, subtotal: $subtotal)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.product.id == product.id;
  }
  
  @override
  int get hashCode => product.id.hashCode;
}
