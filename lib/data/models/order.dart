import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final List<OrderItem> items;
  
  @HiveField(2)
  final double subtotal;
  
  @HiveField(3)
  final double tax;
  
  @HiveField(4)
  final double discount;
  
  @HiveField(5)
  final double total;
  
  @HiveField(6)
  final String paymentMethod;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  final String? customerName;
  
  @HiveField(9)
  final String? customerPhone;
  
  @HiveField(10)
  final String? notes;
  
  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    this.discount = 0,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.customerName,
    this.customerPhone,
    this.notes,
  });
  
  /// Get total number of items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  @override
  String toString() {
    return 'Order(id: $id, total: $total, items: ${items.length})';
  }
}

@HiveType(typeId: 2)
class OrderItem {
  @HiveField(0)
  final String productId;
  
  @HiveField(1)
  final String productName;
  
  @HiveField(2)
  final double unitPrice;
  
  @HiveField(3)
  final int quantity;
  
  @HiveField(4)
  final double subtotal;
  
  OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });
}
