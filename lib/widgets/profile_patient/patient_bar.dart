// lib/widgets/profile_patient/patient_bar.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class PatientBar extends StatelessWidget {
  final String currentRoute;

  const PatientBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLogo(context),
          _buildUserInfo(),
          const SizedBox(height: 24),
          Expanded(child: _buildMainMenu(context)),
          _buildBottomMenu(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => _navigateTo(context, AppRouter.dashboard),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Balance', style: AppTextStyles.logo.copyWith(fontSize: 20)),
                Text('Psy', style: AppTextStyles.logo.copyWith(color: AppColors.primary, fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/avatar/aldiyar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Альдияр', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                Text('Пациент', style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Главная',
        route: AppRouter.dashboard,
      ),
      _MenuItem(
        icon: Icons.people_outlined,
        activeIcon: Icons.people,
        label: 'Специалисты',
        route: AppRouter.contactsPatient,
      ),
      _MenuItem(
        icon: Icons.article_outlined,
        activeIcon: Icons.article,
        label: 'Статьи',
        route: AppRouter.patientArticles,
      ),
      _MenuItem(
        icon: Icons.chat_outlined,
        activeIcon: Icons.chat,
        label: 'Сообщения',
        route: AppRouter.chatPatient,
      ),
    ];

    return Column(
      children: menuItems.map((item) {
        final isActive = currentRoute == item.route;
        return _buildMenuButton(
          context: context,
          item: item,
          isActive: isActive,
        );
      }).toList(),
    );
  }

  Widget _buildBottomMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildMenuButton(
            context: context,
            item: _MenuItem(
              icon: Icons.person_outlined,
              activeIcon: Icons.person,
              label: 'Профиль',
              route: AppRouter.profile,
            ),
            isActive: currentRoute == AppRouter.profile,
          ),
          const SizedBox(height: 8),
          _buildMenuButton(
            context: context,
            item: _MenuItem(
              icon: Icons.logout_outlined,
              activeIcon: Icons.logout,
              label: 'Выйти',
              route: AppRouter.home,
            ),
            isActive: false,
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required _MenuItem item,
    required bool isActive,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _handleNavigation(context, item.route, isLogout),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: AppColors.primary.withOpacity(0.2), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: AppTextStyles.body1.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, String route, bool isLogout) {
    if (currentRoute == route && !isLogout) return;

    if (isLogout) {
      _showLogoutDialog(context);
      return;
    }

    _navigateTo(context, route);
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Выход', style: AppTextStyles.h3),
        content: Text('Вы действительно хотите выйти?', style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Выйти', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  _MenuItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}