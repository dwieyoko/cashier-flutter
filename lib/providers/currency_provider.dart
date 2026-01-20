import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/formatters.dart';
import '../providers/store_config_provider.dart';

/// Provider for formatting currency with store config
final currencyFormatterProvider = Provider<CurrencyFormatter>((ref) {
  final config = ref.watch(storeConfigProvider);
  return CurrencyFormatter(
    symbol: config.currencySymbol,
    code: config.currencyCode,
  );
});

class CurrencyFormatter {
  final String symbol;
  final String code;
  
  CurrencyFormatter({required this.symbol, required this.code});
  
  String format(double amount) {
    return AppFormatters.formatCurrency(amount, symbol: symbol, code: code);
  }
}
