import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/store_config_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeConfig = ref.watch(storeConfigProvider);
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
              ),
            ),
            
            // Store Settings
            SliverToBoxAdapter(
              child: _SectionHeader(title: 'Store Settings', delay: 100),
            ),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsTile(
                    icon: Iconsax.shop,
                    title: 'Store Name',
                    subtitle: storeConfig.storeName,
                    onTap: () => _showEditDialog(
                      context,
                      ref,
                      'Store Name',
                      storeConfig.storeName,
                      (value) => ref.read(storeConfigProvider.notifier).updateStoreName(value),
                    ),
                    delay: 150,
                  ),
                  _SettingsTile(
                    icon: Iconsax.location,
                    title: 'Address',
                    subtitle: storeConfig.address ?? 'Not set',
                    onTap: () => _showEditDialog(
                      context,
                      ref,
                      'Address',
                      storeConfig.address ?? '',
                      (value) => ref.read(storeConfigProvider.notifier).updateAddress(value),
                    ),
                    delay: 200,
                  ),
                  _SettingsTile(
                    icon: Iconsax.call,
                    title: 'Phone',
                    subtitle: storeConfig.phone ?? 'Not set',
                    onTap: () => _showEditDialog(
                      context,
                      ref,
                      'Phone',
                      storeConfig.phone ?? '',
                      (value) => ref.read(storeConfigProvider.notifier).updatePhone(value),
                    ),
                    delay: 250,
                  ),
                ],
                delay: 100,
              ),
            ),
            
            // Appearance
            SliverToBoxAdapter(
              child: _SectionHeader(title: 'Appearance', delay: 300),
            ),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsTile(
                    icon: Iconsax.moon,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: storeConfig.enableDarkMode,
                      onChanged: (_) => ref.read(storeConfigProvider.notifier).toggleDarkMode(),
                      activeColor: AppColors.primary,
                    ),
                    delay: 350,
                  ),
                  _SettingsTile(
                    icon: Iconsax.colorfilter,
                    title: 'Primary Color',
                    trailing: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: storeConfig.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider, width: 2),
                      ),
                    ),
                    onTap: () => _showColorPicker(context, ref),
                    delay: 400,
                  ),
                ],
                delay: 300,
              ),
            ),
            
            // Business Settings
            SliverToBoxAdapter(
              child: _SectionHeader(title: 'Business', delay: 450),
            ),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsTile(
                    icon: Iconsax.dollar_circle,
                    title: 'Currency',
                    subtitle: '${storeConfig.currencySymbol} (${storeConfig.currencyCode})',
                    onTap: () => _showCurrencyPicker(context, ref),
                    delay: 500,
                  ),
                  _SettingsTile(
                    icon: Iconsax.percentage_square,
                    title: 'Tax Rate',
                    subtitle: '${(storeConfig.taxRate * 100).toStringAsFixed(0)}%',
                    onTap: () => _showTaxRateDialog(context, ref, storeConfig.taxRate),
                    delay: 550,
                  ),
                  _SettingsTile(
                    icon: Iconsax.receipt_text,
                    title: 'Receipt Footer',
                    subtitle: storeConfig.receiptFooter ?? 'Not set',
                    onTap: () => _showEditDialog(
                      context,
                      ref,
                      'Receipt Footer',
                      storeConfig.receiptFooter ?? '',
                      (value) => ref.read(storeConfigProvider.notifier).updateReceiptFooter(value),
                    ),
                    delay: 600,
                  ),
                ],
                delay: 450,
              ),
            ),
            
            // About
            SliverToBoxAdapter(
              child: _SectionHeader(title: 'About', delay: 650),
            ),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsTile(
                    icon: Iconsax.info_circle,
                    title: 'Version',
                    subtitle: '1.0.0',
                    delay: 700,
                  ),
                ],
                delay: 650,
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
  
  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter $title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _showColorPicker(BuildContext context, WidgetRef ref) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFEC4899), // Pink
      const Color(0xFFEF4444), // Red
      const Color(0xFFF97316), // Orange
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF10B981), // Emerald
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF3B82F6), // Blue
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) => GestureDetector(
            onTap: () {
              ref.read(storeConfigProvider.notifier).updatePrimaryColor(color.value);
              Navigator.pop(context);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider, width: 2),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }
  
  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    final currencies = [
      ('\$', 'USD'),
      ('€', 'EUR'),
      ('£', 'GBP'),
      ('¥', 'JPY'),
      ('₹', 'INR'),
      ('Rp', 'IDR'),
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) => ListTile(
            title: Text('${currency.$1} (${currency.$2})'),
            onTap: () {
              ref.read(storeConfigProvider.notifier).updateCurrency(
                currency.$1,
                currency.$2,
              );
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
  
  void _showTaxRateDialog(BuildContext context, WidgetRef ref, double currentRate) {
    final controller = TextEditingController(
      text: (currentRate * 100).toStringAsFixed(0),
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tax Rate (%)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            suffixText: '%',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final rate = double.tryParse(controller.text) ?? 10;
              ref.read(storeConfigProvider.notifier).updateTaxRate(rate / 100);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int delay;
  
  const _SectionHeader({required this.title, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms);
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  final int delay;
  
  const _SettingsGroup({required this.children, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardDark
          : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: children,
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay.ms);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int delay;
  
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle != null
        ? Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null,
      trailing: trailing ?? (onTap != null 
        ? Icon(Iconsax.arrow_right_3, color: AppColors.textMuted, size: 18)
        : null),
      onTap: onTap,
    ).animate().fadeIn(duration: 200.ms, delay: delay.ms);
  }
}
