// lib/widgets/home/header.dart
import 'package:flutter/material.dart';
import '../../../сore/router/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class Header extends StatelessWidget {
  final String currentRoute;

  const Header({
    super.key,
    required this.currentRoute,
  });

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
          // Логотип слева
          _buildLogo(context),
          
          // Навигация по центру (только для десктопа) - ТОЛЬКО ЛЕНДИНГ
          if (!isMobile) _buildCenterNavigation(context),
          
          // Кнопки справа - ТОЛЬКО ВХОД/РЕГИСТРАЦИЯ
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
                child: const Icon(Icons.psychology, color: Colors.white, size: 18),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(context, 'Главная', AppRouter.home),
              const SizedBox(width: 8),
              _buildNavItem(context, 'Психологи', AppRouter.psychologists),
              const SizedBox(width: 8),
              _buildNavItem(context, 'Блог', AppRouter.blog),
              const SizedBox(width: 8),

              _buildNavItem(context, 'О нас', AppRouter.about),
              const SizedBox(width: 8),
              _buildNavItem(context, 'Контакты', AppRouter.contacts),
            ],
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            (route) => false,
          );
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
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: isMobile 
          ? _buildMobileMenuButton(context)
          : _buildDesktopActions(context),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
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
            _buildMobileNavItem(context, 'Главная', AppRouter.home, Icons.home),
            _buildMobileNavItem(context, 'Психологи', AppRouter.psychologists, Icons.psychology),
            _buildMobileNavItem(context, 'Блог', AppRouter.blog, Icons.article),

            _buildMobileNavItem(context, 'О нас', AppRouter.about, Icons.info),
            _buildMobileNavItem(context, 'Контакты', AppRouter.contacts, Icons.contact_page),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(BuildContext context, String title, String route, IconData icon) {
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
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            (route) => false,
          );
        }
      },
    );
  }
}