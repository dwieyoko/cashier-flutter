import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';

/// Quantity selector with +/- buttons and animation
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;
  final bool compact;
  
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 999,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = compact ? 28.0 : 36.0;
    final iconSize = compact ? 16.0 : 20.0;
    final fontSize = compact ? 14.0 : 16.0;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _QuantityButton(
            icon: Icons.remove,
            onPressed: quantity > minValue 
              ? () => onChanged(quantity - 1) 
              : null,
            size: buttonSize,
            iconSize: iconSize,
          ),
          
          // Quantity display
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Container(
              key: ValueKey(quantity),
              width: compact ? 32 : 40,
              alignment: Alignment.center,
              child: Text(
                '$quantity',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          
          // Increment button
          _QuantityButton(
            icon: Icons.add,
            onPressed: quantity < maxValue 
              ? () => onChanged(quantity + 1) 
              : null,
            size: buttonSize,
            iconSize: iconSize,
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 200.ms)
      .scale(begin: const Offset(0.9, 0.9), duration: 200.ms);
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  
  const _QuantityButton({
    required this.icon,
    this.onPressed,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: iconSize,
            color: isDisabled 
              ? AppColors.textMuted 
              : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
