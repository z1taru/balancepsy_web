// lib/widgets/web_footer.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../сore/router/app_router.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      color: AppColors.textPrimary,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1120),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 0,
            vertical: 40,
          ),
          child: Column(
            children: [
              if (!isMobile)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: _buildBrandSection()),
                    const SizedBox(width: 40),
                    Expanded(child: _buildNavigationSection(context)),
                    const SizedBox(width: 40),
                    Expanded(child: _buildSupportSection(context)),
                    const SizedBox(width: 40),
                    Expanded(child: _buildContactsSection()),
                  ],
                )
              else
                _buildMobileFooter(context),
              const SizedBox(height: 32),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              _buildCopyright(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Balance',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
            Text(
              'Psy',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Онлайн-платформа для психологической поддержки',
          style: AppTextStyles.body2.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        _buildSocialIcons(),
      ],
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Навигация',
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink(context, 'О нас', AppRouter.about),
        _buildFooterLink(context, 'Психологи', AppRouter.psychologists),
        _buildFooterLink(context, 'Услуги', AppRouter.services),
        _buildFooterLink(context, 'Блог', AppRouter.blog),
        _buildFooterLink(context, 'Контакты', AppRouter.contacts),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Поддержка',
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildFooterLink(context, 'FAQ', '/faq'),
        _buildFooterLink(context, 'Помощь', '/help'),
        _buildFooterLink(context, 'Политика конфиденциальности', '/privacy'),
        _buildFooterLink(context, 'Условия использования', '/terms'),
      ],
    );
  }

  Widget _buildContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Контакты',
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(Icons.email_outlined, 'info@balancepsy.kz'),
        const SizedBox(height: 8),
        _buildContactItem(Icons.phone_outlined, '+7 (777) 123-45-67'),
        const SizedBox(height: 8),
        _buildContactItem(Icons.location_on_outlined, 'Астана, Казахстан'),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
            Text(
              'Psy',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Онлайн-платформа для психологической поддержки',
          style: AppTextStyles.body2.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildSocialIcons(),
        const SizedBox(height: 24),
        _buildContactItem(Icons.email_outlined, 'info@balancepsy.kz'),
        const SizedBox(height: 8),
        _buildContactItem(Icons.phone_outlined, '+7 (777) 123-45-67'),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          style: AppTextStyles.body2.copyWith(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.body2.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialIcon(Icons.facebook, () {}),
        const SizedBox(width: 12),
        _buildSocialIcon(Icons.telegram, () {}),
        const SizedBox(width: 12),
        _buildSocialIcon(Icons.mail_outline, () {}),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCopyright(bool isMobile) {
    return Text(
      '© ${DateTime.now().year} BalancePsy. Все права защищены',
      style: AppTextStyles.body3.copyWith(color: Colors.white70),
      textAlign: isMobile ? TextAlign.center : TextAlign.left,
    );
  }
}
