import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/currency_provider.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'Cash';
  final _customerNameController = TextEditingController();
  bool _isProcessing = false;
  
  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final tax = ref.watch(cartTaxProvider);
    final total = ref.watch(cartTotalProvider);
    final currency = ref.watch(currencyFormatterProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
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
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.receipt_2, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...cartItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.product.name} x${item.quantity}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          currency.format(item.subtotal),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const Divider(),
                  _buildSummaryRow('Subtotal', currency.format(subtotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Tax (10%)', currency.format(tax)),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildSummaryRow(
                    'Total',
                    currency.format(total),
                    isTotal: true,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 24),
            
            // Customer Info (Optional)
            Text(
              'Customer Info (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            const SizedBox(height: 12),
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(
                hintText: 'Customer name',
                prefixIcon: Icon(Iconsax.user, color: AppColors.textMuted),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
            
            const SizedBox(height: 24),
            
            // Payment Method
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            const SizedBox(height: 12),
            
            ...AppConstants.paymentMethods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              return _PaymentMethodTile(
                method: method,
                icon: _getPaymentIcon(method),
                isSelected: _selectedPaymentMethod == method,
                onTap: () => setState(() => _selectedPaymentMethod = method),
                delay: 250 + index * 50,
              );
            }),
            
            const SizedBox(height: 32),
            
            // Complete Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.tick_circle),
                        const SizedBox(width: 12),
                        Text(
                          'Complete Payment ${currency.format(total)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 400.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
                color: AppColors.primary,
              )
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
  
  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Cash':
        return Iconsax.money;
      case 'Card':
        return Iconsax.card;
      case 'Digital Wallet':
        return Iconsax.wallet;
      default:
        return Iconsax.money;
    }
  }
  
  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Create order
    final order = ref.read(ordersProvider.notifier).createOrder(
      paymentMethod: _selectedPaymentMethod,
      customerName: _customerNameController.text.isEmpty 
        ? null 
        : _customerNameController.text,
    );
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(order: order),
        ),
      );
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String method;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;
  
  const _PaymentMethodTile({
    required this.method,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
            ? AppColors.primaryLight.withAlpha(26)
            : Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark
              : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                  ? AppColors.primary
                  : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Iconsax.tick_circle5, color: AppColors.primary),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms).slideX(begin: 0.1);
  }
}
