/// App-wide constants
class AppConstants {
  // App info
  static const String appName = 'CashierPOS';
  static const String appVersion = '1.0.0';
  
  // Default tax rate (can be overridden in store config)
  static const double defaultTaxRate = 0.10; // 10%
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  
  // Icon sizes
  static const double iconSm = 18.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  
  // Product categories
  static const List<String> defaultCategories = [
    'All',
    'Food',
    'Drinks',
    'Snacks',
    'Electronics',
    'Clothing',
    'Other',
  ];
  
  // Payment methods
  static const List<String> paymentMethods = [
    'Cash',
    'Card',
    'Digital Wallet',
  ];
}
