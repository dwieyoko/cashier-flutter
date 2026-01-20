import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/store_config.dart';

/// Service for managing Hive local database
class HiveService {
  static const String productsBox = 'products';
  static const String ordersBox = 'orders';
  static const String storeConfigBox = 'storeConfig';
  
  /// Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());
    Hive.registerAdapter(StoreConfigAdapter());
    
    // Open boxes
    await Hive.openBox<Product>(productsBox);
    await Hive.openBox<Order>(ordersBox);
    await Hive.openBox<StoreConfig>(storeConfigBox);
  }
  
  /// Get products box
  static Box<Product> getProductsBox() {
    return Hive.box<Product>(productsBox);
  }
  
  /// Get orders box
  static Box<Order> getOrdersBox() {
    return Hive.box<Order>(ordersBox);
  }
  
  /// Get store config box
  static Box<StoreConfig> getStoreConfigBox() {
    return Hive.box<StoreConfig>(storeConfigBox);
  }
  
  /// Close all boxes
  static Future<void> close() async {
    await Hive.close();
  }
}
