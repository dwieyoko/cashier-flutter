import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// Animated gradient button with press effect
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  
  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    final defaultGradient = widget.gradient ?? AppColors.primaryGradient;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmall ? 16 : 24,
          vertical: widget.isSmall ? 12 : 16,
        ),
        decoration: BoxDecoration(
          gradient: widget.isOutlined ? null : defaultGradient,
          color: widget.isOutlined ? Colors.transparent : null,
          borderRadius: BorderRadius.circular(12),
          border: widget.isOutlined 
            ? Border.all(color: AppColors.primary, width: 2) 
            : null,
          boxShadow: widget.isOutlined || _isPressed ? null : AppColors.primaryShadow,
        ),
        child: Row(
          mainAxisSize: widget.width != null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.isOutlined ? AppColors.primary : AppColors.textLight,
                  ),
                ),
              )
            else ...[
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.textColor ?? 
                    (widget.isOutlined ? AppColors.primary : AppColors.textLight),
                  size: widget.isSmall ? 18 : 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: AppTypography.buttonText.copyWith(
                  color: widget.textColor ?? 
                    (widget.isOutlined ? AppColors.primary : AppColors.textLight),
                  fontSize: widget.isSmall ? 14 : 16,
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate(target: _isPressed ? 1 : 0)
      .scale(begin: 1, end: 0.95, duration: 150.ms);
  }
}

/// Icon button with ripple effect
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;
  final bool hasBadge;
  final String? badgeText;
  
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.tooltip,
    this.hasBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: size * 0.5,
          ),
        ),
      ),
    );
    
    if (hasBadge) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                badgeText ?? '',
                style: AppTypography.badge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    
    return tooltip != null 
      ? Tooltip(message: tooltip!, child: button) 
      : button;
  }
}
