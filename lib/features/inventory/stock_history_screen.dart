import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/stock_history.dart';
import '../../data/local/hive_service.dart';
import '../../core/utils/formatters.dart';

class StockHistoryScreen extends ConsumerWidget {
  const StockHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyBox = HiveService.getStockHistoryBox();
    final history = historyBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock History'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: history.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.box,
                  size: 80,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 16),
                Text(
                  'No stock history yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ).animate().fadeIn(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: history.length,
            itemBuilder: (context, index) {
              return _HistoryTile(history: history[index], delay: index * 50);
            },
          ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final StockHistory history;
  final int delay;
  
  const _HistoryTile({required this.history, required this.delay});

  @override
  Widget build(BuildContext context) {
    final isNegative = history.changeAmount < 0;
    final icon = _getIcon(history.type);
    final color = _getColor(history.type);
    
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.productName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTypeLabel(history.type),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
                ),
                if (history.reason != null)
                  Text(
                    history.reason!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  AppFormatters.formatDateTime(history.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isNegative ? '' : '+'}${history.changeAmount}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isNegative ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Stock: ${history.newQuantity}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1);
  }
  
  IconData _getIcon(StockChangeType type) {
    switch (type) {
      case StockChangeType.sale:
        return Iconsax.shopping_cart;
      case StockChangeType.restock:
        return Iconsax.box_add;
      case StockChangeType.adjustment:
        return Iconsax.edit;
      case StockChangeType.start:
        return Iconsax.play;
      case StockChangeType.returned:
        return Iconsax.refresh;
    }
  }
  
  Color _getColor(StockChangeType type) {
    switch (type) {
      case StockChangeType.sale:
        return AppColors.error;
      case StockChangeType.restock:
        return AppColors.success;
      case StockChangeType.adjustment:
        return Colors.orange;
      case StockChangeType.start:
        return AppColors.primary;
      case StockChangeType.returned:
        return Colors.blue;
    }
  }
  
  String _getTypeLabel(StockChangeType type) {
    switch (type) {
      case StockChangeType.sale:
        return 'Sale';
      case StockChangeType.restock:
        return 'Restocked';
      case StockChangeType.adjustment:
        return 'Adjustment';
      case StockChangeType.start:
        return 'Initial Stock';
      case StockChangeType.returned:
        return 'Returned';
    }
  }
}
