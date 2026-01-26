// theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Текстовые стили приложения BalancePsy
class AppTextStyles {
  // === Заголовки ===
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 55,
    fontWeight: FontWeight.w600, // SemiBold
    color: Color(0xFF2D2D2D),
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.3,
  );

  // Добавлен h4 — решает ошибку «Member not found: 'h4'»
  static const TextStyle h4 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.4,
  );

  // === Основной текст ===
  static const TextStyle body1 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2D2D2D),
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.5,
  );

  static const TextStyle body3 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.4,
  );

  // === Hero секция ===
  static const TextStyle heroSubtitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.5,
  );

  static const TextStyle heroTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 55,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.2,
  );

  static const TextStyle heroTitleAccent = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 55,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  // === Стили для секции "С чем помогут психологи" ===
  static const TextStyle helpTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 55,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B6B6B),
    height: 1.2,
  );

  static const TextStyle helpTitleAccent = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 55,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  static const TextStyle helpTitleMobile = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B6B6B),
    height: 1.2,
  );

  static const TextStyle helpTitleAccentMobile = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  static const TextStyle helpCardText = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2D2D2D),
    height: 1.5,
  );

  // === Стили для секции "Сделай шаг к заботе о себе" ===
  static const TextStyle stepsTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B6B6B),
    height: 1.2,
  );

  static const TextStyle stepsTitleAccent = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  static const TextStyle stepNumber = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 72,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.0,
  );

  static const TextStyle stepTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.4,
  );

  static const TextStyle stepDescription = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.5,
  );

  // === Стили для команды психологов ===
  static const TextStyle teamTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B6B6B),
    height: 1.2,
  );

  static const TextStyle teamTitleAccent = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  static const TextStyle teamTitleMobile = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B6B6B),
    height: 1.2,
  );

  static const TextStyle teamTitleAccentMobile = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  static const TextStyle teamSubtitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.5,
  );

  static const TextStyle psychologistName = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.3,
  );

  static const TextStyle psychologistExperience = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF7095C6),
    height: 1.4,
  );

  static const TextStyle psychologistSpec = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.4,
  );

  // === Кнопки ===
  static const TextStyle button = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF7095C6),
    height: 1.2,
  );

  // === CTA секция ===
  static const TextStyle ctaTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 36,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle ctaTitleMobile = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle ctaSubtitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.5,
  );

  // === Дополнительные стили ===
  static const TextStyle logo = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D2D2D),
    height: 1.2,
  );

  static const TextStyle tagline = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.4,
  );

  static const TextStyle input = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF2D2D2D),
    height: 1.2,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.3,
  );
  
// ========== ARTICLE ==========
  static const TextStyle articleTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
    fontFamily: 'Manrope',
  );

  static const TextStyle articleBody = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
    fontFamily: 'Manrope',
  );

  static const TextStyle articleQuote = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic,
    height: 1.6,
    fontFamily: 'Manrope',
  );
}
