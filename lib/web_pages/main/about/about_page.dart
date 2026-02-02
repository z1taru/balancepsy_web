import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/web_layout.dart'; // ← ДОБАВЛЕН ИМПОРТ
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../widgets/custom_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.about,
      child: Column(
        children: [
          _buildHeroSection(context, isMobile, isTablet),
          const SizedBox(height: 60),
          _buildMissionSection(context, isMobile, isTablet),
          const SizedBox(height: 80),
          _buildStatsSection(context, isMobile, isTablet),
          const SizedBox(height: 80),
          _buildValuesSection(context, isMobile, isTablet),
          const SizedBox(height: 80),
          _buildTeamSection(context, isMobile, isTablet),
          const SizedBox(height: 80),
          _buildCTASection(context, isMobile, isTablet),
        ],
      ),
    );
  }

  // ✅ ИСПРАВЛЕНИЕ 1: Hero секция
  Widget _buildHeroSection(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity, // ✅ ФОН НА ВЕСЬ ЭКРАН
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
      child: WebLayout.content(
        // ✅ КОНТЕНТ В 1120px
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 80,
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
                'О компании BalancePsy',
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
                          'Мы создаем будущее ментального здоровья',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: isTablet ? 36 : 56,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'BalancePsy — это больше, чем сервис подбора психологов. Это экосистема заботы о себе, объединяющая передовые технологии и человеческое тепло.',
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 20,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            _buildHeroBadge(
                              Icons.check_circle_outline,
                              'Лицензировано',
                            ),
                            const SizedBox(width: 20),
                            _buildHeroBadge(
                              Icons.star_outline,
                              'Топ-специалисты',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      height: 500,
                      padding: const EdgeInsets.only(left: 40),
                      child: SvgPicture.asset(
                        'assets/images/main_page/features.svg',
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
                    'Мы создаем будущее ментального здоровья',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'BalancePsy — это больше, чем сервис подбора психологов. Это экосистема заботы о себе.',
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
                    child: SvgPicture.asset(
                      'assets/images/main_page/features.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ✅ ИСПРАВЛЕНИЕ 2: Mission секция
  Widget _buildMissionSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity, // ✅ ФОН НА ВЕСЬ ЭКРАН
      color: Colors.white,
      child: WebLayout.content(
        // ✅ КОНТЕНТ В 1120px
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: Row(
          children: [
            if (!isMobile && !isTablet)
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/main_page/features-2.png',
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 400,
                        color: AppColors.primary.withOpacity(0.1),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (!isMobile && !isTablet) const SizedBox(width: 60),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Наша миссия',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Мы верим, что забота о ментальном здоровье должна быть такой же естественной и доступной, как утренний кофе. Наша цель — убрать барьеры страха и стигмы, сделав психотерапию комфортной частью жизни.',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildMissionItem(
                    'Доступность',
                    'Помощь в один клик из любой точки мира',
                  ),
                  const SizedBox(height: 20),
                  _buildMissionItem(
                    'Качество',
                    'Строгий отбор специалистов и супервизия',
                  ),
                  const SizedBox(height: 20),
                  _buildMissionItem(
                    'Технологии',
                    'Умный подбор и удобная видеосвязь',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionItem(String title, String desc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                desc,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ ИСПРАВЛЕНИЕ 3: Stats секция
  Widget _buildStatsSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity, // ✅ ФОН НА ВЕСЬ ЭКРАН
      color: AppColors.backgroundLight,
      child: WebLayout.content(
        // ✅ КОНТЕНТ В 1120px
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: 40,
        ),
        child: Wrap(
          spacing: isMobile ? 20 : 60,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: [
            _buildStatCard(
              '3+',
              'Года помощи\nлюдям',
              Icons.calendar_today_outlined,
            ),
            _buildStatCard(
              '1500+',
              'Проведенных\nсессий',
              Icons.favorite_outline,
            ),
            _buildStatCard(
              '98%',
              'Довольных\nклиентов',
              Icons.sentiment_satisfied_alt,
            ),
            _buildStatCard(
              '24/7',
              'Поддержка\nпользователей',
              Icons.headset_mic_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      width: 160,
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              fontSize: 36,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ✅ ИСПРАВЛЕНИЕ 4: Values секция
  Widget _buildValuesSection(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity, // ✅ ФОН НА ВЕСЬ ЭКРАН
      color: Colors.white,
      child: WebLayout.content(
        // ✅ КОНТЕНТ В 1120px
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: Column(
          children: [
            Text(
              'Наши ценности',
              style: AppTextStyles.h2.copyWith(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'То, на чем строится каждое наше решение',
              style: AppTextStyles.body1.copyWith(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: isMobile ? 1.4 : 1.1,
              children: [
                _buildValueCard(
                  Icons.favorite_border,
                  'Эмпатия',
                  'Мы слышим и понимаем каждого, создавая безопасное пространство.',
                  AppColors.primary,
                ),
                _buildValueCard(
                  Icons.verified_user_outlined,
                  'Безопасность',
                  'Ваши данные и истории под надежной защитой шифрования.',
                  AppColors.primary,
                ),
                _buildValueCard(
                  Icons.science_outlined,
                  'Научность',
                  'Используем только доказательные методы психотерапии.',
                  AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ✅ ИСПРАВЛЕНИЕ 5: Team секция
  Widget _buildTeamSection(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity, // ✅ ФОН НА ВЕСЬ ЭКРАН
      color: AppColors.backgroundLight,
      child: WebLayout.content(
        // ✅ КОНТЕНТ В 1120px
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: Column(
          children: [
            Text(
              'Наши эксперты',
              style: AppTextStyles.h2.copyWith(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 48),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _buildTeamMember(
                  'Галия Аубакирова',
                  'Ведущий психолог, КПТ',
                  'assets/images/main_page/galiya1.png',
                ),
                _buildTeamMember(
                  'Яна Прозорова',
                  'Семейный терапевт',
                  'assets/images/main_page/yana1.png',
                ),
                _buildTeamMember(
                  'Лаура Болдина',
                  'Психолог личности',
                  'assets/images/main_page/laura1.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String imagePath) {
    return Container(
      width: 250,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          ClipOval(
            child: Container(
              width: 120,
              height: 120,
              color: AppColors.backgroundLight,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.textSecondary,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: AppTextStyles.h3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            role,
            style: AppTextStyles.body2.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ✅ ИСПРАВЛЕНИЕ 6: CTA секция
  Widget _buildCTASection(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity, // ✅ ФОН НА ВЕСЬ ЭКРАН
      color: AppColors.backgroundLight,
      child: WebLayout.content(
        // ✅ КОНТЕНТ В 1120px
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 30 : 60),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Готовы начать?',
                style: AppTextStyles.h2.copyWith(
                  fontSize: isMobile ? 28 : 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Запишитесь на первую консультацию уже сегодня и сделайте шаг навстречу гармонии.',
                style: AppTextStyles.body1.copyWith(
                  fontSize: isMobile ? 16 : 20,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Подобрать психолога',
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.psychologists);
                },
                isPrimary: false,
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                icon: Icons.arrow_forward,
                isFullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
