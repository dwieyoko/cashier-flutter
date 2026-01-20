import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/orders_provider.dart';
import '../../providers/store_config_provider.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/bottom_nav.dart';
import '../reports/analytics_screen.dart';
import '../../features/inventory/stock_history_screen.dart';
import '../../data/models/order.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeConfig = ref.watch(storeConfigProvider);
    final currency = ref.watch(currencyFormatterProvider);
    final todaysSales = ref.watch(todaysSalesProvider);
    final todaysOrderCount = ref.watch(todaysOrderCountProvider);
    final recentOrders = ref.watch(ordersProvider).take(5).toList();
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back 👋',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
                            const SizedBox(height: 4),
                            Text(
                              storeConfig.storeName,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(begin: -0.1),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Iconsax.notification,
                            color: AppColors.primary,
                          ),
                        ).animate().fadeIn(duration: 300.ms, delay: 200.ms).scale(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: "Today's Sales",
                            value: currency.format(todaysSales),
                            icon: Iconsax.money_4,
                            gradient: AppColors.primaryGradient,
                            delay: 0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Orders',
                            value: '$todaysOrderCount',
                            icon: Iconsax.receipt_2,
                            gradient: AppColors.successGradient,
                            delay: 100,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _QuickActionButton(
                          icon: Iconsax.shopping_cart,
                          label: 'New Sale',
                          color: AppColors.primary,
                          onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 3,
                          delay: 500,
                        ),
                        const SizedBox(width: 12),
                        _QuickActionButton(
                          icon: Iconsax.scan_barcode,
                          label: 'Scan',
                          color: AppColors.secondary,
                          onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 2,
                          delay: 600,
                        ),
                        const SizedBox(width: 12),
                        _QuickActionButton(
                          icon: Iconsax.document_text,
                          label: 'History',
                          color: Colors.orange,
                          onTap: () {
                            // History is available in the Reports screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AnalyticsScreen(),
                              ),
                            );
                          },
                          delay: 200,
                        ),
                        const SizedBox(width: 12), // Added SizedBox for spacing
                        _QuickActionButton(
                          icon: Iconsax.chart_2,
                          label: 'Reports',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AnalyticsScreen(),
                              ),
                            );
                          },
                          delay: 250,
                        ),
                        const SizedBox(width: 12), // Added SizedBox for spacing
                        _QuickActionButton(
                          icon: Iconsax.box_time,
                          label: 'Stock',
                          color: Colors.teal,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StockHistoryScreen(),
                              ),
                            );
                          },
                          delay: 300,
                        ),
                        const SizedBox(width: 12), // Added SizedBox for spacing
                        _QuickActionButton(
                          icon: Iconsax.box,
                          label: 'Products',
                          color: AppColors.warning,
                          onTap: () => ref.read(bottomNavIndexProvider.notifier).state = 1,
                          delay: 700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Recent Orders Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Orders',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 800.ms),
              ),
            ),
            
            // Recent Orders List
            if (recentOrders.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.receipt_text,
                        size: 64,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start making sales to see them here',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 900.ms),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final order = recentOrders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: GestureDetector(
                        onTap: () => _showOrderDetails(context, order, ref),
                        child: AppCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Iconsax.receipt_2,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppFormatters.formatOrderId(order.id),
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    Text(
                                      '${order.totalItems} items • ${AppFormatters.formatTime(order.createdAt)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                currency.format(order.total),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms, delay: (900 + index * 100).ms)
                          .slideY(begin: 0.1),
                      ),
                    );
                  },
                  childCount: recentOrders.length,
                ),
              ),
            
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showOrderDetails(BuildContext context, Order order, WidgetRef ref) {
    final currency = ref.read(currencyFormatterProvider);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppFormatters.formatOrderId(order.id),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              AppFormatters.formatDateTime(order.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.productName} x${item.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    currency.format(item.subtotal),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  currency.format(order.subtotal),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  currency.format(order.tax),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currency.format(order.total),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.card, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Payment: ${order.paymentMethod}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final int delay;
  
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradient.colors.first).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms).scale(begin: const Offset(0.9, 0.9));
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int delay;
  
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
