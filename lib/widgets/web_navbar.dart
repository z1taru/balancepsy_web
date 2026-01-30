import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../core/router/app_router.dart';
import 'custom_button.dart';

class WebNavbar extends StatefulWidget {
  final String? currentRoute;

  const WebNavbar({super.key, this.currentRoute});

  @override
  State<WebNavbar> createState() => _WebNavbarState();
}

class _WebNavbarState extends State<WebNavbar> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context, isMobile),
          if (!isMobile && !isTablet) _buildDesktopMenu(context),
          _buildActions(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isMobile) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.home),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'Balance',
            style: AppTextStyles.logo.copyWith(fontSize: isMobile ? 20 : 24),
          ),
          Text(
            'Psy',
            style: AppTextStyles.logo.copyWith(
              fontSize: isMobile ? 20 : 24,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopMenu(BuildContext context) {
    return Row(
      children: AppRouter.routes.entries.map((entry) {
        final isActive = widget.currentRoute == entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, entry.value),
            child: Text(
              entry.key,
              style: AppTextStyles.body1.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActions(BuildContext context, bool isMobile) {
    if (isMobile) {
      return IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textPrimary),
        onPressed: () => _showMobileMenu(context),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 44,
          child: CustomButton(
            text: 'Войти',
            onPressed: () => Navigator.pushNamed(context, AppRouter.login),
            isPrimary: false,
            isFullWidth: true,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 140,
          height: 44,
          child: CustomButton(
            text: 'Регистрация',
            onPressed: () => Navigator.pushNamed(context, AppRouter.register),
            isPrimary: true,
            isFullWidth: true,
          ),
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ...AppRouter.routes.entries.map((entry) {
              final isActive = widget.currentRoute == entry.value;
              return ListTile(
                title: Text(
                  entry.key,
                  style: AppTextStyles.body1.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, entry.value);
                },
              );
            }),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                      text: 'Войти',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRouter.login);
                      },
                      isPrimary: false,
                      isFullWidth: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomButton(
                      text: 'Регистрация',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRouter.register);
                      },
                      isPrimary: true,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
