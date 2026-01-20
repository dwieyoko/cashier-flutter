import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/products/products_screen.dart';
import '../features/scanner/scanner_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/settings/settings_screen.dart';
import '../widgets/bottom_nav.dart';

/// Main app shell with bottom navigation
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          DashboardScreen(),
          ProductsScreen(),
          ScannerScreen(),
          CartScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
      extendBody: true,
    );
  }
}
