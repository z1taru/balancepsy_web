import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../сore/router/app_router.dart';
import '../../widgets/custom_button.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.services,
      child: Column(
        children: [
          _buildHeroSection(isMobile, isTablet),
          const SizedBox(height: 40),
          _buildServicesGrid(isMobile, isTablet),
          const SizedBox(height: 80),
          _buildProcessSection(isMobile, isTablet),
          const SizedBox(height: 80),
          _buildPricingSection(isMobile, isTablet),
          const SizedBox(height: 80),
          _buildCTASection(isMobile),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 60 : 100,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                _buildHeroTag(),
                const SizedBox(height: 30),
                Text(
                  'Путь к себе начинается здесь',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Мы предлагаем различные форматы терапии, чтобы вы могли выбрать именно тот, который подходит вашему образу жизни и запросам.',
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroTag(),
                      const SizedBox(height: 30),
                      Text(
                        'Путь к себе начинается здесь',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Мы предлагаем различные форматы терапии, чтобы вы могли выбрать именно тот, который подходит вашему образу жизни и запросам.',
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.spa_outlined,
                        size: 150,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeroTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        'Наши услуги',
        style: AppTextStyles.body2.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildServicesGrid(bool isMobile, bool isTablet) {
    final services = [
      _ServiceData(
        'Индивидуальная терапия',
        'Работа один на один с психологом для глубокой проработки личных запросов.',
        Icons.person_outline,
        ['Тревожность и стресс', 'Личные границы', 'Самооценка', 'Депрессия'],
        AppColors.primary,
      ),
      _ServiceData(
        'Парная терапия',
        'Помощь парам в преодолении кризисов и построении гармоничных отношений.',
        Icons.favorite_border,
        ['Конфликты', 'Утрата доверия', 'Развод', 'Коммуникация'],
        const Color(0xFFE56B6F),
      ),
      _ServiceData(
        'Подростковая терапия',
        'Бережная поддержка подростков в период взросления и самоопределения.',
        Icons.school_outlined,
        ['Проблемы в школе', 'Отношения с родителями', 'Буллинг', 'Выбор профессии'],
        const Color(0xFF6D597A),
      ),
      _ServiceData(
        'Коучинг',
        'Фокус на достижении целей, карьере и личностном росте.',
        Icons.rocket_launch_outlined,
        ['Карьерный рост', 'Мотивация', 'Тайм-менеджмент', 'Лидерство'],
        const Color(0xFF355070),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 2);
          double aspectRatio = isMobile ? 0.8 : 1.3;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: aspectRatio,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = -1),
                child: _buildServiceCard(services[index], index == _hoveredIndex, isMobile),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(_ServiceData service, bool isHovered, bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()..translate(0.0, isHovered ? -10.0 : 0.0),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isHovered ? service.color.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: service.color.withOpacity(isHovered ? 0.15 : 0.05),
            blurRadius: isHovered ? 30 : 20,
            offset: Offset(0, isHovered ? 15 : 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(service.icon, size: 32, color: service.color),
              ),
              Icon(
                Icons.arrow_outward,
                color: isHovered ? service.color : AppColors.textSecondary.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            service.title,
            style: AppTextStyles.h3.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service.description,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: AppTextStyles.body2.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
      ),
      child: Column(
        children: [
          Text(
            'Как это работает',
            style: AppTextStyles.h2.copyWith(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: [
                    _buildProcessStep('1', 'Заполните анкету', 'Ответьте на несколько вопросов, чтобы мы подобрали идеального специалиста.', isLast: false),
                    _buildProcessStep('2', 'Выберите психолога', 'Изучите профили рекомендованных специалистов и отзывы.', isLast: false),
                    _buildProcessStep('3', 'Начните терапию', 'Забронируйте удобное время и подключитесь к видеозвонку.', isLast: true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildProcessStep('1', 'Заполните анкету', 'Ответьте на несколько вопросов, чтобы мы подобрали идеального специалиста.', isLast: false)),
                    Expanded(child: _buildProcessStep('2', 'Выберите психолога', 'Изучите профили рекомендованных специалистов и отзывы.', isLast: false)),
                    Expanded(child: _buildProcessStep('3', 'Начните терапию', 'Забронируйте удобное время и подключитесь к видеозвонку.', isLast: true)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String desc, {required bool isLast}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number,
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
              ),
            ),
             if (!isLast)
              Positioned(
                 right: -100, // Not precise for all screens, simpler to hide connection lines for now or make custom painter. 
                 // Let's keep it simple without lines for stability or use a separator widget.
                 child: SizedBox(), 
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTextStyles.h3.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            desc,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPricingSection(bool isMobile, bool isTablet) {
     return Container(
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 0),
      ),
      child: Column(
        children: [
          Text(
            'Стоимость консультаций',
            style: AppTextStyles.h2.copyWith(fontSize: 36, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
           Text(
            'Прозрачные цены без скрытых платежей',
            style: AppTextStyles.body1.copyWith(fontSize: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildPriceCard('Начинающий', '10 000 ₸', [
                'Дипломированный специалист',
                'Опыт от 1 года',
                'Регулярная супервизия',
                '50 минут сессия'
              ], false),
              _buildPriceCard('Опытный', '15 000 ₸', [
                'Опыт от 3 лет',
                'Доп. специализации',
                'Высокий рейтинг',
                '50 минут сессия',
                'Поддержка в чате'
              ], true),
              _buildPriceCard('Эксперт', '25 000 ₸', [
                'Опыт от 7 лет',
                'Ученая степень',
                'Премиум сервис',
                '60 минут сессия',
                'Личное сопровождение'
              ], false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String title, String price, List<String> features, bool isHighlighted) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: isHighlighted ? Colors.white : AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            price,
            style: AppTextStyles.h2.copyWith(
              color: isHighlighted ? Colors.white : AppColors.primary,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
           Text(
            '/ сессия',
            style: AppTextStyles.body2.copyWith(
              color: isHighlighted ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 20, color: isHighlighted ? Colors.white : AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: AppTextStyles.body2.copyWith(
                      color: isHighlighted ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Выбрать',
            onPressed: () {},
            isPrimary: !isHighlighted, 
            backgroundColor: isHighlighted ? Colors.white : AppColors.primary,
            textColor: isHighlighted ? AppColors.primary : Colors.white,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
             constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(40),
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
                  'Не уверены, что выбрать?',
                  style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: isMobile ? 28 : 36),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Пройдите наш короткий тест, и мы подберем для вас идеального специалиста и формат работы бесплатно.',
                  style: AppTextStyles.body1.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: isMobile ? double.infinity : 250,
                  child: CustomButton(
                    text: 'Пройти тест',
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceData {
  final String title;
  final String description;
  final IconData icon;
  final List<String> tags;
  final Color color;

  _ServiceData(this.title, this.description, this.icon, this.tags, this.color);
}
