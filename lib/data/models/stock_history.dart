import 'package:hive/hive.dart';

part 'stock_history.g.dart';

@HiveType(typeId: 5)
enum StockChangeType {
  @HiveField(0)
  sale,
  @HiveField(1)
  restock,
  @HiveField(2)
  adjustment,
  @HiveField(3)
  start,
  @HiveField(4)
  returned,
}

@HiveType(typeId: 4)
class StockHistory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final int changeAmount;

  @HiveField(4)
  final int newQuantity;

  @HiveField(5)
  final StockChangeType type;

  @HiveField(6)
  final String? reason;

  @HiveField(7)
  final DateTime timestamp;

  StockHistory({
    required this.id,
    required this.productId,
    required this.productName,
    required this.changeAmount,
    required this.newQuantity,
    required this.type,
    this.reason,
    required this.timestamp,
  });
}
