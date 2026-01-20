import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/order.dart';
import '../../providers/currency_provider.dart';

class PaymentSuccessScreen extends ConsumerWidget {
  final Order order;
  
  const PaymentSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyFormatterProvider);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.successGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withAlpha(77),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ).animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut)
                .fadeIn(),
              
              const SizedBox(height: 32),
              
              // Success Text
              Text(
                'Payment Successful!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.2),
              
              const SizedBox(height: 8),
              
              Text(
                'Transaction completed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
              
              const SizedBox(height: 32),
              
              // Order Details Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.cardDark
                    : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Order ID',
                      value: AppFormatters.formatOrderId(order.id),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Date',
                      value: AppFormatters.formatDateTime(order.createdAt),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Payment',
                      value: order.paymentMethod,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Items',
                      value: '${order.totalItems} items',
                    ),
                    const Divider(height: 32),
                    _DetailRow(
                      label: 'Total',
                      value: currency.format(order.total),
                      isTotal: true,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideY(begin: 0.2),
              
              const Spacer(),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Print receipt
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Print feature coming soon!')),
                        );
                      },
                      icon: const Icon(Iconsax.printer),
                      label: const Text('Print'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Iconsax.home),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms, delay: 500.ms).slideY(begin: 0.2),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  
  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
            ? Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              )
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: isTotal
            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              )
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
