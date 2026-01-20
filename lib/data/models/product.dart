import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final String? barcode;
  
  @HiveField(5)
  final String? imageUrl;
  
  @HiveField(6)
  final String category;
  
  @HiveField(7)
  final int stockQuantity;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final DateTime? updatedAt;
  
  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.barcode,
    this.imageUrl,
    required this.category,
    this.stockQuantity = 0,
    required this.createdAt,
    this.updatedAt,
  });
  
  /// Create a copy with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? barcode,
    String? imageUrl,
    String? category,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, barcode: $barcode)';
  }
}
