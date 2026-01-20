import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'store_config.g.dart';

/// White-label configuration for the store
/// Allows customization of branding, colors, and business settings
@HiveType(typeId: 3)
class StoreConfig extends HiveObject {
  @HiveField(0)
  final String storeName;
  
  @HiveField(1)
  final String? logoUrl;
  
  @HiveField(2)
  final int primaryColorValue;
  
  @HiveField(3)
  final int secondaryColorValue;
  
  @HiveField(4)
  final String currencySymbol;
  
  @HiveField(5)
  final String currencyCode;
  
  @HiveField(6)
  final double taxRate;
  
  @HiveField(7)
  final String? receiptFooter;
  
  @HiveField(8)
  final String? address;
  
  @HiveField(9)
  final String? phone;
  
  @HiveField(10)
  final bool enableDarkMode;
  
  StoreConfig({
    this.storeName = 'My Store',
    this.logoUrl,
    this.primaryColorValue = 0xFF6366F1,
    this.secondaryColorValue = 0xFF06B6D4,
    this.currencySymbol = '\$',
    this.currencyCode = 'USD',
    this.taxRate = 0.10,
    this.receiptFooter = 'Thank you for your purchase!',
    this.address,
    this.phone,
    this.enableDarkMode = false,
  });
  
  /// Get primary color as Color object
  Color get primaryColor => Color(primaryColorValue);
  
  /// Get secondary color as Color object
  Color get secondaryColor => Color(secondaryColorValue);
  
  /// Create a copy with updated fields
  StoreConfig copyWith({
    String? storeName,
    String? logoUrl,
    int? primaryColorValue,
    int? secondaryColorValue,
    String? currencySymbol,
    String? currencyCode,
    double? taxRate,
    String? receiptFooter,
    String? address,
    String? phone,
    bool? enableDarkMode,
  }) {
    return StoreConfig(
      storeName: storeName ?? this.storeName,
      logoUrl: logoUrl ?? this.logoUrl,
      primaryColorValue: primaryColorValue ?? this.primaryColorValue,
      secondaryColorValue: secondaryColorValue ?? this.secondaryColorValue,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCode: currencyCode ?? this.currencyCode,
      taxRate: taxRate ?? this.taxRate,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      enableDarkMode: enableDarkMode ?? this.enableDarkMode,
    );
  }
  
  /// Default store configuration
  static StoreConfig get defaultConfig => StoreConfig();
}
