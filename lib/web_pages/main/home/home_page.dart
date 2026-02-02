// lib/web_pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../core/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      currentRoute: AppRouter.home,
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildHelpSection(context),
          _buildStepsSection(context),
          _buildPsychologistsSection(context),
          _buildArticlesPromoSection(context),
        ],
      ),
    );
  }

  // HERO SECTION только с кнопкой "Выбрать психолога"
  Widget _buildHeroSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isMobile ? 20 : 0,
      ),
      decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: isMobile
              ? Column(
                  children: [
                    _buildHeroContent(context, isMobile),
                    const SizedBox(height: 24),
                    _buildHeroImage(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: _buildHeroContent(context, isMobile),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(flex: 6, child: _buildHeroImage()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Сервис онлайн психотерапии',
          style: AppTextStyles.heroSubtitle,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Твоя ', style: AppTextStyles.heroTitle),
              TextSpan(
                text: 'поддержка\n',
                style: AppTextStyles.heroTitleAccent,
              ),
              TextSpan(text: 'Твой ', style: AppTextStyles.heroTitle),
              TextSpan(text: 'баланс', style: AppTextStyles.heroTitleAccent),
            ],
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),

        // Только кнопка выбора психолога
        SizedBox(
          width: isMobile ? double.infinity : 240,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.psychologists);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7095C6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text('Выбрать психолога', style: AppTextStyles.button),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Image.asset(
      'assets/images/main_page/phone1.png',
      fit: BoxFit.contain,
      height: 650,
      errorBuilder: (_, __, ___) =>
          _buildImagePlaceholder(1350, Icons.phone_android),
    );
  }

  // Секция "С чем помогут психологи"
  Widget _buildHelpSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 10 : 30,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Stack(
            children: [
              _buildFeaturesImage(isMobile),
              Positioned(
                top: isMobile ? 65 : 95,
                left: isMobile ? -70 : -50,
                child: SizedBox(
                  width: isMobile ? 300 : 400,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'С чем\n',
                          style: isMobile
                              ? AppTextStyles.helpTitleMobile.copyWith(
                                  height: 0.9,
                                )
                              : AppTextStyles.helpTitle.copyWith(height: 0.9),
                        ),
                        TextSpan(
                          text: 'помогут\n',
                          style: isMobile
                              ? AppTextStyles.helpTitleAccentMobile.copyWith(
                                  height: 0.9,
                                )
                              : AppTextStyles.helpTitleAccent.copyWith(
                                  height: 0.9,
                                ),
                        ),
                        TextSpan(
                          text: 'психологи',
                          style: isMobile
                              ? AppTextStyles.helpTitleMobile.copyWith(
                                  height: 0.9,
                                )
                              : AppTextStyles.helpTitle.copyWith(height: 0.9),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesImage(bool isMobile) {
    return Image.asset(
      'assets/images/main_page/features-2.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: isMobile ? 410 : 540,
      errorBuilder: (_, __, ___) =>
          _buildImagePlaceholder(540, Icons.psychology, color: Colors.grey),
    );
  }

  // Секция "Сделай шаг к заботе о себе"
  Widget _buildStepsSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FA),
      child: isMobile ? _buildStepsMobile() : _buildStepsDesktop(),
    );
  }

  Widget _buildStepsMobile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          _buildStepsTitle(),
          const SizedBox(height: 40),
          _buildStepsImage(),
          const SizedBox(height: 40),
          _buildStepsListHorizontal(isMobile: true),
        ],
      ),
    );
  }

  Widget _buildStepsDesktop() {
    return Column(
      children: [
        SizedBox(
          height: 700,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(right: 0, top: 50, child: _buildStepsImage()),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 100),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepsTitle(),
                        const SizedBox(height: 60),
                        _buildStepsListHorizontal(isMobile: false),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStepsTitle() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Сделай шаг к ', style: AppTextStyles.stepsTitle),
          TextSpan(text: 'заботе\n', style: AppTextStyles.stepsTitleAccent),
          TextSpan(text: 'о себе', style: AppTextStyles.stepsTitle),
        ],
      ),
    );
  }

  Widget _buildStepsImage() {
    return SvgPicture.asset(
      'assets/images/main_page/woman.svg',
      width: 1029,
      height: 566,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildImagePlaceholder(
        566,
        Icons.person,
        background: Colors.orange[300],
      ),
    );
  }

  Widget _buildStepsListHorizontal({required bool isMobile}) {
    final step = (String num, String title, String desc) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: _buildStepItemCompact(num, title, desc),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepItemCompact(
            '1',
            'Укажите темы, с которыми хотите поработать',
            'Это могут быть тревожность, выгорание, сложности в отношениях, самооценка и многое другое.',
          ),
          const SizedBox(height: 24),
          _buildStepItemCompact(
            '2',
            'Выберите комфортную для себя стоимость сессии',
            'Это могут быть тревожность, выгорание, сложности в отношениях, самооценка и многое другое.',
          ),
          const SizedBox(height: 24),
          _buildStepItemCompact(
            '3',
            'Получите подборку опытных специалистов под ваш запрос',
            'Это могут быть тревожность, выгорание, сложности в отношениях, самооценка и многое другое.',
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        step(
          '1',
          'Укажите темы, с которыми хотите поработать',
          'Это могут быть тревожность, выгорание, сложности в отношениях, самооценка и многое другое.',
        ),
        const SizedBox(width: 20),
        step(
          '2',
          'Выберите комфортную для себя стоимость сессии',
          'Это могут быть тревожность, выгорание, сложности в отношениях, самооценка и многое другое.',
        ),
        const SizedBox(width: 20),
        step(
          '3',
          'Получите подборку опытных специалистов под ваш запрос',
          'Это могут быть тревожность, выгорание, сложности в отношениях, самооценка и многое другое.',
        ),
      ],
    );
  }

  Widget _buildStepItemCompact(
    String number,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number, style: AppTextStyles.stepNumber),
        const SizedBox(height: 8),
        Text(title, style: AppTextStyles.stepTitle),
        const SizedBox(height: 6),
        Text(description, style: AppTextStyles.stepDescription),
      ],
    );
  }

  // Секция "Команда психологов"
  Widget _buildPsychologistsSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F7FA),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Команда ',
                      style: isMobile
                          ? AppTextStyles.teamTitleMobile
                          : AppTextStyles.teamTitle,
                    ),
                    TextSpan(
                      text: 'психологов',
                      style: isMobile
                          ? AppTextStyles.teamTitleAccentMobile
                          : AppTextStyles.teamTitleAccent,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Специализированные психологи со стажем работы',
                style: AppTextStyles.teamSubtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  _buildPsychologistCard(
                    'Галия Аубакирова',
                    '7 лет опыта',
                    'Психолог, нутрициолог взрослый и детский',
                    'galiya1.png',
                  ),
                  _buildPsychologistCard(
                    'Яна Прозорова',
                    '15 лет опыта',
                    'Психолог (КПТ, схема терапия)',
                    'yana1.png',
                  ),
                  _buildPsychologistCard(
                    'Лаура Болдина',
                    '7 лет опыта',
                    'Психолог (КПТ, гештальт)',
                    'laura1.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPsychologistCard(
    String name,
    String experience,
    String spec,
    String imageName,
  ) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF7095C6), width: 4),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/main_page/$imageName',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF7095C6).withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Color(0xFF7095C6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: AppTextStyles.psychologistName,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            experience,
            style: AppTextStyles.psychologistExperience,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            spec,
            style: AppTextStyles.psychologistSpec,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Секция промо статей
  Widget _buildArticlesPromoSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: isMobile ? _buildArticlesMobile() : _buildArticlesDesktop(),
        ),
      ),
    );
  }

  Widget _buildArticlesDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/main_page/phone2.png',
          width: 320,
          height: 520,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildPhonePlaceholder(320, 520),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: _buildArticlesText(textAlign: TextAlign.left),
          ),
        ),
      ],
    );
  }

  Widget _buildArticlesMobile() {
    return Column(
      children: [
        Image.asset(
          'assets/images/main_page/phone2.png',
          width: 220,
          height: 400,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildPhonePlaceholder(220, 400),
        ),
        const SizedBox(height: 32),
        _buildArticlesText(textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildArticlesText({TextAlign textAlign = TextAlign.left}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 42),
        Text(
          'BalancePsy',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF454545),
            height: 1.2,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 16),
        Text(
          'Читайте актуальные',
          style: AppTextStyles.stepsTitle.copyWith(height: 1.0),
          textAlign: textAlign,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'статьи ',
                style: AppTextStyles.stepsTitleAccent.copyWith(height: 1.0),
              ),
              TextSpan(
                text: 'от наших',
                style: AppTextStyles.stepsTitle.copyWith(height: 1.0),
              ),
            ],
          ),
          textAlign: textAlign,
        ),
        Text(
          'психологов',
          style: AppTextStyles.stepsTitle.copyWith(height: 1.0),
          textAlign: textAlign,
        ),
      ],
    );
  }

  // Вспомогательные методы для placeholder'ов
  Widget _buildImagePlaceholder(
    double height,
    IconData icon, {
    Color? background,
    Color? color,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: Icon(icon, size: 100, color: color ?? Colors.grey)),
    );
  }

  Widget _buildPhonePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.phone_android, size: 90, color: Colors.grey),
    );
  }
}
