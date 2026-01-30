// lib/widgets/unified_sidebar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../core/router/app_router.dart';
import '../web_pages/services/user_provider.dart';

/// Универсальный Sidebar для клиента и психолога
/// Автоматически адаптируется под роль пользователя
class UnifiedSidebar extends StatelessWidget {
  final String currentRoute;

  const UnifiedSidebar({super.key, required this.currentRoute});

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
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final isPsychologist = userProvider.userRole == 'PSYCHOLOGIST';

          return Column(
            children: [
              _buildLogo(context),
              _buildUserInfo(context, userProvider),
              const SizedBox(height: 24),
              Expanded(child: _buildMainMenu(context, isPsychologist)),
              _buildBottomMenu(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.home),
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
                Text(
                  'Balance',
                  style: AppTextStyles.logo.copyWith(fontSize: 20),
                ),
                Text(
                  'Psy',
                  style: AppTextStyles.logo.copyWith(
                    color: AppColors.primary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserProvider userProvider) {
    // Показываем загрузку
    if (userProvider.isLoading && userProvider.user == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    // Если пользователь не загружен
    if (!userProvider.isAuthenticated) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.person_outline, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              'Гость',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Показываем реальные данные пользователя
    final userName = userProvider.userName ?? 'Пользователь';
    final avatarUrl = userProvider.userAvatar;
    final userRole = _getRoleText(userProvider.userRole);
    final firstName = _getFirstName(userName);

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
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarPlaceholder(userName);
                      },
                    )
                  : _buildAvatarPlaceholder(userName),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userRole,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String userName) {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Text(
          _getInitials(userName),
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context, bool isPsychologist) {
    final menuItems = isPsychologist
        ? _getPsychologistMenuItems()
        : _getClientMenuItems();

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

  List<_MenuItem> _getPsychologistMenuItems() {
    return [
      _MenuItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Главная',
        route: AppRouter.psychoDashboard,
      ),
      _MenuItem(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
        label: 'Расписание',
        route: AppRouter.psychoSchedule,
      ),
      _MenuItem(
        icon: Icons.chat_outlined,
        activeIcon: Icons.chat,
        label: 'Сообщения',
        route: AppRouter.psychoMessages,
      ),
      _MenuItem(
        icon: Icons.assessment_outlined,
        activeIcon: Icons.assessment,
        label: 'Отчеты',
        route: AppRouter.psychoReports,
      ),
    ];
  }

  List<_MenuItem> _getClientMenuItems() {
    return [
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
              color: isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    )
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
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
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

    Navigator.pushNamed(context, route);
  }

  void _showLogoutDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Выход', style: AppTextStyles.h3),
        content: Text(
          'Вы действительно хотите выйти?',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Отмена',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await userProvider.performLogout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.home,
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Выйти', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  String _getFirstName(String fullName) {
    if (fullName.isEmpty) return 'Пользователь';
    return fullName.split(' ').first;
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return 'П';
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }

  String _getRoleText(String? role) {
    switch (role) {
      case 'CLIENT':
        return 'Пациент';
      case 'PSYCHOLOGIST':
        return 'Психолог';
      case 'ADMIN':
        return 'Администратор';
      default:
        return 'Пользователь';
    }
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
