import 'package:flutter/material.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../widgets/custom_button.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.contacts,
      child: Column(
        children: [
          _buildHeroSection(isMobile, isTablet),
          const SizedBox(height: 60),
          _buildContentSection(isMobile, isTablet),
          const SizedBox(height: 80),
          _buildMapSection(isMobile, isTablet),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 60 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.backgroundLight,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Связь с нами',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!isMobile)
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Мы всегда рядом,\nчтобы помочь',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: isTablet ? 36 : 56,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'У вас есть вопросы о платформе или нужна помощь в подборе специалиста? Наша команда поддержки готова ответить на любые вопросы.',
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 20,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    height: 400,
                    child: Image.asset(
                      'assets/images/main_page/phone2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  'Мы всегда рядом,\nчтобы помочь',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'У вас есть вопросы о платформе или нужна помощь в подборе специалиста? Наша команда поддержки готова ответить на любые вопросы.',
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/main_page/phone2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildContactInfoCards(isMobile),
            const SizedBox(height: 60),
            _buildFeedbackForm(isMobile),
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: _buildContactInfoCards(isMobile),
          ),
          const SizedBox(width: 60),
          Expanded(
            flex: 6,
            child: _buildFeedbackForm(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCards(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Контакты',
          style: AppTextStyles.h2.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 32),
        _buildInfoCard(
          icon: Icons.email_outlined,
          title: 'Email',
          value: 'support@balancepsy.kz',
          subtitle: 'Отвечаем в течение 24 часов',
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          icon: Icons.phone_outlined,
          title: 'Телефон',
          value: '+7 (777) 123-45-67',
          subtitle: 'Пн-Пт, с 9:00 до 18:00',
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          icon: Icons.location_on_outlined,
          title: 'Офис',
          value: 'г. Алматы',
          subtitle: 'пр. Абая 10, офис 305',
        ),
        const SizedBox(height: 40),
        Text(
          'Мы в соцсетях',
          style: AppTextStyles.h3.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSocialButton(Icons.telegram),
            const SizedBox(width: 16),
            _buildSocialButton(Icons.camera_alt_outlined), // Instagram-like
            const SizedBox(width: 16),
            _buildSocialButton(Icons.link), // LinkedIn-like
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Напишите нам',
            style: AppTextStyles.h2.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Заполните форму, и мы свяжемся с вами в ближайшее время.',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField('Ваше имя', _nameController, Icons.person_outline),
          const SizedBox(height: 20),
          _buildTextField('Email', _emailController, Icons.email_outlined),
          const SizedBox(height: 20),
          _buildTextField(
            'Сообщение',
            _messageController,
            Icons.message_outlined,
            maxLines: 4,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Отправить сообщение',
            onPressed: () {},
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTextStyles.body1,
            decoration: InputDecoration(
              hintText: 'Введите $label',
              hintStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              prefixIcon: maxLines == 1
                  ? Icon(icon, color: AppColors.textSecondary)
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Icon(icon, color: AppColors.textSecondary),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              fillColor: AppColors.backgroundLight,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 60, color: AppColors.primary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              'Карта местоположения',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Алматы, пр. Абая 10, офис 305',
              style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
