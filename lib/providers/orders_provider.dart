import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/order.dart';
import '../data/models/cart_item.dart';
import '../data/local/hive_service.dart';
import 'cart_provider.dart';

/// Provider for orders list
final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier(ref);
});

/// Provider for today's orders
final todaysOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(ordersProvider);
  final today = DateTime.now();
  return orders.where((o) => 
    o.createdAt.year == today.year &&
    o.createdAt.month == today.month &&
    o.createdAt.day == today.day
  ).toList();
});

/// Provider for today's total sales
final todaysSalesProvider = Provider<double>((ref) {
  final todaysOrders = ref.watch(todaysOrdersProvider);
  return todaysOrders.fold(0, (sum, order) => sum + order.total);
});

/// Provider for today's order count
final todaysOrderCountProvider = Provider<int>((ref) {
  return ref.watch(todaysOrdersProvider).length;
});

/// Provider for weekly sales data (Last 7 days)
final weeklySalesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final orders = ref.watch(ordersProvider);
  final today = DateTime.now();
  final last7Days = List.generate(7, (index) {
    final date = today.subtract(Duration(days: 6 - index));
    return DateTime(date.year, date.month, date.day);
  });
  
  return last7Days.map((date) {
    final daysOrders = orders.where((o) =>
      o.createdAt.year == date.year &&
      o.createdAt.month == date.month &&
      o.createdAt.day == date.day
    );
    
    final sales = daysOrders.fold(0.0, (sum, o) => sum + o.total);
    
    return {
      'day': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
      'date': date,
      'sales': sales,
    };
  }).toList();
});

/// Provider for top selling products
final topProductsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final orders = ref.watch(ordersProvider);
  final productSales = <String, Map<String, dynamic>>{};
  
  for (final order in orders) {
    for (final item in order.items) {
      if (!productSales.containsKey(item.productId)) {
        productSales[item.productId] = {
          'id': item.productId,
          'name': item.productName,
          'quantity': 0,
          'revenue': 0.0,
        };
      }
      
      productSales[item.productId]!['quantity'] += item.quantity;
      productSales[item.productId]!['revenue'] += item.subtotal;
    }
  }
  
  final sortedProducts = productSales.values.toList()
    ..sort((a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int));
    
  return sortedProducts.take(5).toList();
});

/// Provider for total revenue (All time)
final totalRevenueProvider = Provider<double>((ref) {
  final orders = ref.watch(ordersProvider);
  return orders.fold(0, (sum, order) => sum + order.total);
});

/// Provider for average order value
final averageOrderValueProvider = Provider<double>((ref) {
  final orders = ref.watch(ordersProvider);
  if (orders.isEmpty) return 0;
  final totalRevenue = ref.watch(totalRevenueProvider);
  return totalRevenue / orders.length;
});

class OrdersNotifier extends StateNotifier<List<Order>> {
  final Ref _ref;
  final _uuid = const Uuid();
  
  OrdersNotifier(this._ref) : super([]) {
    _loadOrders();
  }
  
  /// Load orders from local storage
  void _loadOrders() {
    final box = HiveService.getOrdersBox();
    state = box.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
  
  /// Create order from current cart
  Order createOrder({
    required String paymentMethod,
    double discount = 0,
    String? customerName,
    String? customerPhone,
    String? notes,
  }) {
    final cart = _ref.read(cartProvider);
    final subtotal = _ref.read(cartSubtotalProvider);
    final tax = _ref.read(cartTaxProvider);
    final total = subtotal + tax - discount;
    
    final orderItems = cart.map((item) => OrderItem(
      productId: item.product.id,
      productName: item.product.name,
      unitPrice: item.product.price,
      quantity: item.quantity,
      subtotal: item.subtotal,
    )).toList();
    
    final order = Order(
      id: _uuid.v4(),
      items: orderItems,
      subtotal: subtotal,
      tax: tax,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      customerName: customerName,
      customerPhone: customerPhone,
      notes: notes,
    );
    
    // Save to Hive
    final box = HiveService.getOrdersBox();
    box.put(order.id, order);
    
    // Update state
    state = [order, ...state];
    
    // Clear cart
    _ref.read(cartProvider.notifier).clearCart();
    
    return order;
  }
  
  /// Delete an order
  void deleteOrder(String id) {
    final box = HiveService.getOrdersBox();
    box.delete(id);
    state = state.where((o) => o.id != id).toList();
  }
}
