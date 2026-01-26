import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Кастомная кнопка с различными вариантами дизайна
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary; // true - синяя кнопка, false - белая кнопка
  final bool isOutlined; // true - обводка без заливки
  final IconData? icon; // Иконка для кнопки
  final bool showArrow; // Показывать стрелку справа

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isOutlined = false,
    this.icon,
    this.showArrow = false,
    this.backgroundColor,
    this.textColor,
    this.isFullWidth = true,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: 56,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(28),
        border: isOutlined
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: isPrimary && !isOutlined
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: _getTextColor(), size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: isPrimary
                      ? AppTextStyles.button
                      : AppTextStyles.buttonSecondary,
                ),
                if (showArrow) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: _getTextColor(), size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Определяем цвет фона кнопки
  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    if (isOutlined) return Colors.transparent;
    return isPrimary ? AppColors.primary : AppColors.background;
  }

  // Определяем цвет текста кнопки
  Color _getTextColor() {
    if (textColor != null) return textColor!;
    if (isOutlined) return AppColors.primary;
    return isPrimary ? AppColors.textWhite : AppColors.primary;
  }
}
