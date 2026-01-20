import 'package:intl/intl.dart';

/// Utility class for formatting values
class AppFormatters {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');
  
  /// Format price as currency with custom symbol
  /// IDR uses no decimals, other currencies use 2 decimals
  static String formatCurrency(double amount, {String symbol = '\$', String code = 'USD'}) {
    // IDR and JPY typically don't use decimal places
    final noDecimalCurrencies = ['IDR', 'JPY', 'KRW', 'VND'];
    final decimalDigits = noDecimalCurrencies.contains(code) ? 0 : 2;
    
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    
    return formatter.format(amount);
  }
  
  /// Format price with store config (legacy support)
  static String formatPrice(double amount) {
    return formatCurrency(amount);
  }
  
  /// Format date only
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  /// Format time only
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }
  
  /// Format date and time
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }
  
  /// Format quantity with unit
  static String formatQuantity(int quantity, {String? unit}) {
    if (unit != null) {
      return '$quantity $unit';
    }
    return quantity.toString();
  }
  
  /// Format order ID for display
  static String formatOrderId(String id) {
    if (id.length > 8) {
      return '#${id.substring(0, 8).toUpperCase()}';
    }
    return '#${id.toUpperCase()}';
  }
}
