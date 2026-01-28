// lib/web_pages/psycho/psycho_schedule.dart

import 'package:balance_psy/widgets/unified_sidebar.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';

class PsychoSchedulePage extends StatelessWidget {
  const PsychoSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          UnifiedSidebar(currentRoute: '/psycho/schedule'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildCalendarSection(),
                  const SizedBox(height: 24),
                  _buildTodaySessions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Расписание приёмов',
              style: AppTextStyles.h1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Октябрь 2025',
                  style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Добавить сессию'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Календарь', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final dates = ['7', '8', '9', '10', '11', '12', '13'];

    return Column(
      children: [
        // Дни недели
        Row(
          children: days.map((day) => Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.3))),
              ),
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )).toList(),
        ),
        // Даты
        Row(
          children: dates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;
            final isToday = date == '9'; // Текущий день
            final hasSession = date == '9' || date == '11'; // Дни с сессиями

            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.1)),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      date,
                      style: AppTextStyles.body1.copyWith(
                        color: isToday ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (hasSession) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTodaySessions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Сегодняшние приёмы', style: AppTextStyles.h2),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Все →',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSessionItem(
            'Альдияр Байдилла',
            'Сегодня, 15:30',
            'Тревожность',
            'assets/images/avatar/aldiyar.png',
            'ожидается',
          ),
          const SizedBox(height: 16),
          _buildSessionItem(
            'Рамина Канатовна',
            'Сегодня, 17:00',
            'Влюбленность',
            'assets/images/avatar/ramina.png',
            'подтверждена',
          ),
          const SizedBox(height: 16),
          _buildSessionItem(
            'Ажар Алимбет',
            'Сегодня, 20:30',
            'Самооценка',
            'assets/images/avatar/azhar.png',
            'отменена',
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(String name, String time, String topic, String avatar, String status) {
    Color statusColor;
    switch (status) {
      case 'ожидается':
        statusColor = Colors.orange;
      case 'подтверждена':
        statusColor = AppColors.success;
      case 'отменена':
        statusColor = Colors.red;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(avatar),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(topic, style: AppTextStyles.body2),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(time, style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: AppTextStyles.body3.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}