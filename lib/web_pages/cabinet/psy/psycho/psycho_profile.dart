// lib/web_pages/psycho/psycho_profile.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/psycho/psycho_sidebar.dart';
import '../../../services/user_provider.dart';
import '../../../../сore/router/app_router.dart';

class PsychoProfilePage extends StatefulWidget {
  const PsychoProfilePage({super.key});

  @override
  State<PsychoProfilePage> createState() => _PsychoProfilePageState();
}

class _PsychoProfilePageState extends State<PsychoProfilePage> {
  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  void _checkUserRole() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Если пользователь — клиент, редиректим
      if (userProvider.userRole == 'CLIENT') {
        Navigator.pushReplacementNamed(context, AppRouter.profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          PsychoSidebar(currentRoute: '/psycho/profile'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildProfileCard(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildRecommendations(),
                  const SizedBox(height: 24),
                  _buildActionsSection(),
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
        Text('Мой профиль', style: AppTextStyles.h1.copyWith(fontSize: 28)),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit, size: 20),
          label: const Text('Редактировать профиль'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage(
              'assets/images/avatar/galiya.png',
            ),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Галия Нубакирова',
                  style: AppTextStyles.h2.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Психолог BalancePsy',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Специализация: КПТ, гештальт-терапия, работа с тревожностью',
                  style: AppTextStyles.body2,
                ),
                Text('Опыт работы: 7+ лет', style: AppTextStyles.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
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
          Text('Моя статистика', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatItem('7+', 'лет опыта'),
              const SizedBox(width: 40),
              _buildStatItem('439', 'сеансов'),
              const SizedBox(width: 40),
              _buildStatItem('4.9', 'рейтинг'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h1.copyWith(
            fontSize: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
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
          Text('Мои рекомендации', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            'Попробуйте 5-минутную медитацию перед сном',
            Icons.nightlight_round,
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            'Прочитайте статью: "Как говорить о чувствах"',
            Icons.article,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.body1)),
      ],
    );
  }

  Widget _buildActionsSection() {
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
          Text('Действия', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          _buildActionItem('Уведомления', Icons.notifications_outlined),
          const SizedBox(height: 12),
          _buildActionItem('Темная тема', Icons.dark_mode_outlined),
          const SizedBox(height: 12),
          _buildActionItem('Помощь и поддержка', Icons.help_outline),
          const SizedBox(height: 20),
          Divider(color: AppColors.inputBorder.withOpacity(0.3)),
          const SizedBox(height: 16),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildActionItem(String text, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textPrimary, size: 20),
              const SizedBox(width: 12),
              Text(text, style: AppTextStyles.body1),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          await userProvider.performLogout();
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.home,
              (route) => false,
            );
          }
        },
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Выйти из аккаунта'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
