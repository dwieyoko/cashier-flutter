import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/store_config.dart';
import '../data/local/hive_service.dart';

/// Provider for store configuration (white-label settings)
final storeConfigProvider = StateNotifierProvider<StoreConfigNotifier, StoreConfig>((ref) {
  return StoreConfigNotifier();
});

/// Provider for dark mode state
final darkModeProvider = Provider<bool>((ref) {
  return ref.watch(storeConfigProvider).enableDarkMode;
});

class StoreConfigNotifier extends StateNotifier<StoreConfig> {
  StoreConfigNotifier() : super(StoreConfig.defaultConfig) {
    _loadConfig();
  }
  
  /// Load config from local storage
  void _loadConfig() {
    final box = HiveService.getStoreConfigBox();
    if (box.isNotEmpty) {
      state = box.values.first;
    }
  }
  
  /// Update store configuration
  void updateConfig(StoreConfig config) {
    final box = HiveService.getStoreConfigBox();
    box.put('config', config);
    state = config;
  }
  
  /// Update store name
  void updateStoreName(String name) {
    updateConfig(state.copyWith(storeName: name));
  }
  
  /// Update primary color
  void updatePrimaryColor(int colorValue) {
    updateConfig(state.copyWith(primaryColorValue: colorValue));
  }
  
  /// Update secondary color
  void updateSecondaryColor(int colorValue) {
    updateConfig(state.copyWith(secondaryColorValue: colorValue));
  }
  
  /// Update currency
  void updateCurrency(String symbol, String code) {
    updateConfig(state.copyWith(currencySymbol: symbol, currencyCode: code));
  }
  
  /// Update tax rate
  void updateTaxRate(double rate) {
    updateConfig(state.copyWith(taxRate: rate));
  }
  
  /// Toggle dark mode
  void toggleDarkMode() {
    updateConfig(state.copyWith(enableDarkMode: !state.enableDarkMode));
  }
  
  /// Update receipt footer
  void updateReceiptFooter(String footer) {
    updateConfig(state.copyWith(receiptFooter: footer));
  }
  
  /// Update store address
  void updateAddress(String address) {
    updateConfig(state.copyWith(address: address));
  }
  
  /// Update store phone
  void updatePhone(String phone) {
    updateConfig(state.copyWith(phone: phone));
  }
}
