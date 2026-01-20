import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/orders_provider.dart';
import '../../providers/currency_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklySales = ref.watch(weeklySalesProvider);
    final topProducts = ref.watch(topProductsProvider);
    final totalRevenue = ref.watch(totalRevenueProvider);
    final totalOrders = ref.watch(ordersProvider).length;
    final avgOrderValue = ref.watch(averageOrderValueProvider);
    final currency = ref.watch(currencyFormatterProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                _MetricCard(
                  title: 'Total Revenue',
                  value: currency.format(totalRevenue),
                  icon: Iconsax.money,
                  color: AppColors.primary,
                  delay: 0,
                ),
                _MetricCard(
                  title: 'Total Orders',
                  value: totalOrders.toString(),
                  icon: Iconsax.shopping_bag,
                  color: AppColors.secondary,
                  delay: 100,
                ),
                _MetricCard(
                  title: 'Avg. Order Value',
                  value: currency.format(avgOrderValue),
                  icon: Iconsax.receipt_2,
                  color: Colors.orange,
                  delay: 200,
                ),
                _MetricCard(
                  title: 'Top Product',
                  value: topProducts.isNotEmpty ? topProducts.first['name'] : '-',
                  icon: Iconsax.star,
                  color: Colors.pink,
                  delay: 300,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Weekly Sales Chart
            Text(
              'Weekly Sales',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            
            Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppColors.cardShadow,
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: weeklySales.fold<double>(0, (max, item) => item['sales'] > max ? item['sales'] : max) * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => AppColors.primary,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          currency.format(rod.toY),
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < weeklySales.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                weeklySales[value.toInt()]['day'],
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: weeklySales.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data['sales'],
                          color: AppColors.primary,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: weeklySales.fold<double>(0, (max, item) => item['sales'] > max ? item['sales'] : max) * 1.2,
                            color: AppColors.background,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).scale(),
            
            const SizedBox(height: 32),
            
            // Top Products List
            Text(
              'Top Products',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 16),
            
            ...topProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index < 3 ? AppColors.primary : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          color: index < 3 ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${product['quantity']} sold',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      currency.format(product['revenue']),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (700 + index * 100).ms).slideX(begin: 0.1);
            }),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;
  
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).scale();
  }
}
