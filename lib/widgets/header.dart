import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../сore/router/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../web_pages/services/user_provider.dart';

class Header extends StatelessWidget {
  final String currentRoute;

  const Header({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      height: 70,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context),
          if (!isMobile) _buildCenterNavigation(context),
          _buildActions(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: () {
          if (currentRoute != AppRouter.home) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.home,
              (route) => false,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Balance',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Psy',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavigation(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavItem(context, 'Главная', AppRouter.home),
                const SizedBox(width: 8),
                _buildNavItem(context, 'Психологи', AppRouter.psychologists),
                const SizedBox(width: 8),
                _buildNavItem(context, 'О сервисе', AppRouter.about),
                const SizedBox(width: 8),
                _buildNavItem(context, 'Контакты', AppRouter.contacts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    final isActive = currentRoute == route;

    return GestureDetector(
      onTap: () {
        if (currentRoute != route) {
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: AppTextStyles.body1.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isMobile) {
    // ВАЖНО: Используем Consumer для отслеживания изменений
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        print(
          'Header rebuild - isAuthenticated: ${userProvider.isAuthenticated}',
        );
        print('Header rebuild - userName: ${userProvider.userName}');

        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: userProvider.isAuthenticated
              ? (isMobile
                    ? _buildMobileMenuButton(context)
                    : _buildAuthenticatedActions(context, userProvider))
              : (isMobile
                    ? _buildMobileMenuButton(context)
                    : _buildDesktopActions(context)),
        );
      },
    );
  }

  Widget _buildDesktopActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.login),
              child: Text(
                'Войти',
                style: AppTextStyles.body1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.register),
              child: Text(
                'Регистрация',
                style: AppTextStyles.body1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedActions(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final maxNameWidth = MediaQuery.of(context).size.width < 1024
        ? 120.0
        : 180.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка профиля
          GestureDetector(
            onTap: () {
              // Переход в личный кабинет в зависимости от роли
              final role = userProvider.userRole;
              final profileRoute = AppRouter.getProfileRoute(role);
              Navigator.pushNamed(context, profileRoute);
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    backgroundImage: userProvider.userAvatar != null
                        ? NetworkImage(userProvider.userAvatar!)
                        : null,
                    child: userProvider.userAvatar == null
                        ? Text(
                            (userProvider.userName ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxNameWidth),
                    child: Text(
                      userProvider.userName ?? 'Профиль',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Кнопка выхода
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            color: AppColors.error,
            tooltip: 'Выйти',
            onPressed: () async {
              await userProvider.performLogout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.home,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 20),
        onPressed: () => _showMobileMenu(context),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    // Получаем текущее состояние авторизации через Consumer
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isAuthenticated = userProvider.isAuthenticated;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              _buildMobileNavItem(
                context,
                'Главная',
                AppRouter.home,
                Icons.home,
              ),
              _buildMobileNavItem(
                context,
                'Психологи',
                AppRouter.psychologists,
                Icons.psychology,
              ),
              _buildMobileNavItem(
                context,
                'О сервисе',
                AppRouter.about,
                Icons.info,
              ),
              _buildMobileNavItem(
                context,
                'Контакты',
                AppRouter.contacts,
                Icons.contact_page,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              if (isAuthenticated) ...[
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      final role = userProvider.userRole;
                      final profileRoute = AppRouter.getProfileRoute(role);
                      Navigator.pushNamed(context, profileRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Профиль',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await userProvider.performLogout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.home,
                          (route) => false,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Выйти',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRouter.login);
                    },
                    child: Text(
                      'Войти',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRouter.register);
                    },
                    child: Text(
                      'Регистрация',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (currentRoute != route) {
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        }
      },
    );
  }
}
