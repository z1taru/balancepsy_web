// lib/web_pages/psycho/psycho_reports.dart

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/psycho/psycho_sidebar.dart';

class PsychoReportsPage extends StatelessWidget {
  const PsychoReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          PsychoSidebar(currentRoute: '/psycho/reports'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  _buildRecentReports(),
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
              'Мои отчеты',
              style: AppTextStyles.h1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Статистика и история сессий',
              style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download, size: 20),
          label: const Text('Экспорт отчетов'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('8', 'всего отчетов', Icons.assessment, Colors.blue)),
        const SizedBox(width: 20),
        Expanded(child: _buildStatCard('3', 'за эту неделю', Icons.trending_up, Colors.green)),
        const SizedBox(width: 20),
        Expanded(child: _buildStatCard('12', 'сессий проведено', Icons.event_available, Colors.orange)),
        const SizedBox(width: 20),
        Expanded(child: _buildStatCard('4.9', 'средний рейтинг', Icons.star, Colors.purple)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReports() {
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
              Text('Последние отчеты', style: AppTextStyles.h2),
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
          _buildReportItem(
            'Альдияр Байдилла',
            'Тема: Тревожность',
            '12 октября 2024',
            'assets/images/avatar/aldiyar.png',
          ),
          const SizedBox(height: 16),
          _buildReportItem(
            'Рамина Канатовна',
            'Тема: Влюбленность',
            '10 октября 2024',
            'assets/images/avatar/ramina.png',
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String name, String topic, String date, String avatar) {
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
                Text(date, style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Посмотреть'),
          ),
        ],
      ),
    );
  }
}