// lib/widgets/psycho/psycho_sidebar.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class PsychoSidebar extends StatelessWidget {
  final String currentRoute;

  const PsychoSidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildLogo(context),
          const SizedBox(height: 48),
          _buildMenuItem(
            context,
            Icons.dashboard_outlined,
            'Главная',
            currentRoute == AppRouter.psychoDashboard,
            AppRouter.psychoDashboard,
          ),
          _buildMenuItem(
            context,
            Icons.calendar_today,
            'Расписание',
            currentRoute == AppRouter.psychoSchedule,
            AppRouter.psychoSchedule,
          ),
          _buildMenuItem(
            context,
            Icons.chat_bubble_outline,
            'Сообщения',
            currentRoute == AppRouter.psychoMessages,
            AppRouter.psychoMessages,
          ),
          _buildMenuItem(
            context,
            Icons.assessment_outlined,
            'Мои отчеты',
            currentRoute == AppRouter.psychoReports,
            AppRouter.psychoReports,
          ),
          _buildMenuItem(
            context,
            Icons.person_outline,
            'Профиль',
            currentRoute == AppRouter.psychoProfile,
            AppRouter.psychoProfile,
          ),
          const Spacer(),
          _buildProfileCard(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.home),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 8),
          Text('Balance', style: AppTextStyles.logo.copyWith(fontSize: 22)),
          Text(
            'Psy',
            style: AppTextStyles.logo.copyWith(
              fontSize: 22,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    bool isActive,
    String route,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: const AssetImage('assets/images/avatar/galiya.png'),
            onBackgroundImageError: (_, __) {},
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Галия Аубакирова',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Психолог',
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Выход'),
                  content: const Text('Вы уверены, что хотите выйти?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.home,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Выйти'),
                    ),
                  ],
                ),
              );
            },
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}