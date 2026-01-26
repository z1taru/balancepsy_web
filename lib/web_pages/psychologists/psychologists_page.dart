// lib/web_pages/psychologists/psychologists_page.dart (с добавленной девушкой)
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Добавляем импорт для SVG
import '../../widgets/page_wrapper.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';
import '../../widgets/custom_button.dart';

class PsychologistsPage extends StatefulWidget {
  const PsychologistsPage({super.key});

  @override
  State<PsychologistsPage> createState() => _PsychologistsPageState();
}

class _PsychologistsPageState extends State<PsychologistsPage> {
  String _selectedSpecialization = 'Все';
  String _selectedExperience = 'Любой';
  String _selectedPrice = 'Любая';

  final List<String> _specializations = [
    'Все',
    'Тревожность',
    'Депрессия',
    'Отношения',
    'Самооценка',
    'Стресс',
    'Выгорание',
    'Панические атаки',
    'Семейная терапия',
    'Детская психология',
  ];

  final List<String> _experiences = ['Любой', '1-3 года', '3-5 лет', '5+ лет'];
  final List<String> _prices = ['Любая', 'до 10 000 ₸', '10-15 000 ₸', '15 000+ ₸'];

  final List<Map<String, dynamic>> _psychologists = [
    {
      'id': '1',
      'name': 'Галия Аубакирова',
      'photo': 'assets/images/main_page/galiya1.png',
      'specialization': 'Когнитивно-поведенческая терапия',
      'experience': '8 лет',
      'experienceNum': 8,
      'rating': 4.9,
      'reviews': 127,
      'price': '15 000',
      'priceNum': 15000,
      'education': 'КазНУ им. Аль-Фараби, психология',
      'certificates': ['КПТ-терапевт', 'Гештальт-терапия'],
      'helps': ['Тревожность', 'Депрессия', 'Панические атаки', 'ОКР', 'Фобии'],
      'description': 'Помогаю справиться с тревожностью, депрессией и паническими атаками. Работаю в подходе когнитивно-поведенческой терапии.',
      'languages': ['Русский', 'Казахский', 'Английский'],
      'sessionDuration': '50 минут',
      'tags': ['Топ-специалист', 'Эксперт КПТ'],
      'available': true,
    },
    {
      'id': '2',
      'name': 'Яна Прозорова',
      'photo': 'assets/images/main_page/yana1.png',
      'specialization': 'Семейная и парная терапия',
      'experience': '10 лет',
      'experienceNum': 10,
      'rating': 5.0,
      'reviews': 203,
      'price': '18 000',
      'priceNum': 18000,
      'education': 'МГУ им. Ломоносова, клиническая психология',
      'certificates': ['Семейный психолог', 'Эмоционально-фокусированная терапия'],
      'helps': ['Отношения', 'Семейные конфликты', 'Развод', 'Измена', 'Коммуникация'],
      'description': 'Специализируюсь на работе с парами и семьями. Помогаю восстановить близость и найти взаимопонимание.',
      'languages': ['Русский', 'Английский'],
      'sessionDuration': '60 минут',
      'tags': ['Семейный психолог', 'ЭФТ эксперт'],
      'available': true,
    },
    {
      'id': '3',
      'name': 'Лаура Болдина',
      'photo': 'assets/images/main_page/laura1.png',
      'specialization': 'Психотерапия самооценки',
      'experience': '7 лет',
      'experienceNum': 7,
      'rating': 4.8,
      'reviews': 95,
      'price': '14 000',
      'priceNum': 14000,
      'education': 'НИУ ВШЭ, психология личности',
      'certificates': ['Позитивная психотерапия', 'Арт-терапия'],
      'helps': ['Самооценка', 'Уверенность в себе', 'Самопознание', 'Кризис идентичности'],
      'description': 'Работаю с вопросами самооценки, помогаю обрести уверенность и найти себя.',
      'languages': ['Русский', 'Казахский'],
      'sessionDuration': '50 минут',
      'tags': ['Эксперт по самооценке'],
      'available': true,
    },
    {
      'id': '4',
      'name': 'Алдияр Нурланов',
      'photo': 'assets/images/avatar/aldiyar.png',
      'specialization': 'Стресс-менеджмент',
      'experience': '6 лет',
      'experienceNum': 6,
      'rating': 4.7,
      'reviews': 78,
      'price': '13 000',
      'priceNum': 13000,
      'education': 'КБТУ, организационная психология',
      'certificates': ['Коуч ICC', 'Mindfulness-практик'],
      'helps': ['Стресс', 'Выгорание', 'Карьера', 'Work-life баланс'],
      'description': 'Специализируюсь на работе со стрессом и профессиональным выгоранием.',
      'languages': ['Русский', 'Казахский', 'Английский'],
      'sessionDuration': '50 минут',
      'tags': ['Стресс-коуч', 'Mindfulness'],
      'available': true,
    },
    {
      'id': '5',
      'name': 'Диана Жумабаева',
      'photo': 'assets/images/avatar/diana.png',
      'specialization': 'Детская психология',
      'experience': '9 лет',
      'experienceNum': 9,
      'rating': 4.9,
      'reviews': 156,
      'price': '16 000',
      'priceNum': 16000,
      'education': 'КазНПУ им. Абая, педагогическая психология',
      'certificates': ['Детский психолог', 'Игровая терапия'],
      'helps': ['Детские страхи', 'Поведение', 'Развитие', 'Подростки'],
      'description': 'Работаю с детьми и подростками. Помогаю справиться со страхами и эмоциональным состоянием.',
      'languages': ['Русский', 'Казахский'],
      'sessionDuration': '45 минут',
      'tags': ['Детский психолог', 'Игровая терапия'],
      'available': true,
    },
    {
      'id': '6',
      'name': 'Айгерим Сарсенова',
      'photo': 'assets/images/avatar/aigerim.png',
      'specialization': 'Гештальт-терапия',
      'experience': '5 лет',
      'experienceNum': 5,
      'rating': 4.6,
      'reviews': 64,
      'price': '12 000',
      'priceNum': 12000,
      'education': 'ЕНУ им. Гумилева, клиническая психология',
      'certificates': ['Гештальт-терапевт', 'Телесно-ориентированная терапия'],
      'helps': ['Эмоции', 'Самопознание', 'Отношения', 'Личные границы'],
      'description': 'Помогаю понять свои эмоции и потребности, выстроить здоровые отношения.',
      'languages': ['Русский', 'Казахский', 'Турецкий'],
      'sessionDuration': '50 минут',
      'tags': ['Гештальт-терапевт'],
      'available': false,
    },
    {
      'id': '7',
      'name': 'Арман Касымов',
      'photo': 'assets/images/psychologists/arman.png',
      'specialization': 'Тревога и панические атаки',
      'experience': '4 года',
      'experienceNum': 4,
      'rating': 4.5,
      'reviews': 42,
      'price': '11 000',
      'priceNum': 11000,
      'education': 'КазНУ им. Аль-Фараби, клиническая психология',
      'certificates': ['КПТ-терапевт', 'EMDR-практик'],
      'helps': ['Тревожность', 'Панические атаки', 'Фобии', 'Посттравматическое расстройство'],
      'description': 'Специализируюсь на работе с тревогой, паническими атаками и травмой.',
      'languages': ['Русский', 'Казахский'],
      'sessionDuration': '50 минут',
      'tags': ['EMDR', 'Тревога'],
      'available': true,
    },
    {
      'id': '8',
      'name': 'Сауле Исмаилова',
      'photo': 'assets/images/psychologists/saule.png',
      'specialization': 'Эмоциональный интеллект',
      'experience': '12 лет',
      'experienceNum': 12,
      'rating': 4.9,
      'reviews': 189,
      'price': '20 000',
      'priceNum': 20000,
      'education': 'МГУ им. Ломоносова, психология',
      'certificates': ['EQ-коуч', 'Нейропсихолог'],
      'helps': ['Эмоциональный интеллект', 'Саморегуляция', 'Эмпатия', 'Коммуникация'],
      'description': 'Помогаю развить эмоциональный интеллект и навыки саморегуляции.',
      'languages': ['Русский', 'Казахский', 'Английский'],
      'sessionDuration': '60 минут',
      'tags': ['Топ-специалист', 'EQ эксперт'],
      'available': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredPsychologists {
    List<Map<String, dynamic>> result = List.from(_psychologists);

    if (_selectedSpecialization != 'Все') {
      result = result.where((p) {
        final helps = p['helps'] as List<String>;
        return helps.contains(_selectedSpecialization);
      }).toList();
    }

    if (_selectedExperience != 'Любой') {
      result = result.where((p) {
        final exp = p['experienceNum'] as int;
        if (_selectedExperience == '1-3 года') return exp >= 1 && exp <= 3;
        if (_selectedExperience == '3-5 лет') return exp >= 3 && exp <= 5;
        if (_selectedExperience == '5+ лет') return exp >= 5;
        return true;
      }).toList();
    }

    if (_selectedPrice != 'Любая') {
      result = result.where((p) {
        final price = p['priceNum'] as int;
        if (_selectedPrice == 'до 10 000 ₸') return price <= 10000;
        if (_selectedPrice == '10-15 000 ₸') return price > 10000 && price <= 15000;
        if (_selectedPrice == '15 000+ ₸') return price > 15000;
        return true;
      }).toList();
    }

    return result;
  }

  void _resetFilters() {
    setState(() {
      _selectedSpecialization = 'Все';
      _selectedExperience = 'Любой';
      _selectedPrice = 'Любая';
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.psychologists,
      child: Column(
              children: [
                _buildHeroSection(isMobile, isTablet),
                _buildStatsSection(isMobile, isTablet),
                _buildFiltersSection(isMobile, isTablet),
                _buildPsychologistsGrid(isMobile, isTablet),
                _buildCTASection(isMobile, isTablet),
              ],
            ),

    );
  }

  Widget _buildHeroSection(bool isMobile, bool isTablet) {
    final isDesktop = !isMobile && !isTablet;

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
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroTag(),
                      const SizedBox(height: 24),
                      Text(
                        'Наши психологи — ваши проводники к балансу',
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Каждый специалист проходит строгий отбор, имеет высшее образование, сертификаты и регулярно повышает квалификацию. Мы подберем психолога именно под ваш запрос.',
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 20,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: 600,
                    child: SvgPicture.asset(
                      'assets/images/main_page/woman.svg',
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildHeroTag(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Наши психологи — ваши проводники к балансу',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Каждый специалист проходит строгий отбор, имеет высшее образование, сертификаты и регулярно повышает квалификацию. Мы подберем психолога именно под ваш запрос.',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: isMobile ? 18 : 20,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 60),
          if (!isMobile)
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _buildHeroFeature('🎯', 'Индивидуальный подбор', 'под ваш запрос и цели'),
                _buildHeroFeature('⭐', 'Только проверенные', 'специалисты с опытом 3+ лет'),
                _buildHeroFeature('💼', 'Лицензии и сертификаты', 'подтвержденная квалификация'),
                _buildHeroFeature('💬', 'Бесплатная поддержка', 'помощь с выбором психолога'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeroTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        'Команда экспертов',
        style: AppTextStyles.body1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHeroFeature(String emoji, String title, String subtitle) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      color: Colors.white,
      child: Wrap(
        spacing: isMobile ? 20 : 40,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildStatItem('${_psychologists.length}', 'Психологов в команде'),
          Container(width: 1, height: 40, color: AppColors.inputBorder),
          _buildStatItem('1500+', 'Консультаций в месяц'),
          Container(width: 1, height: 40, color: AppColors.inputBorder),
          _buildStatItem('4.8', 'Средний рейтинг'),
          Container(width: 1, height: 40, color: AppColors.inputBorder),
          _buildStatItem('98%', 'Довольных клиентов'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              fontSize: 36,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      color: AppColors.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Найдите своего психолога',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Отфильтруйте специалистов по нужным критериям',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isMobile ? 16 : 18,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: _resetFilters,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Сбросить фильтры',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          // Специализации
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Специализация',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _specializations.map((spec) {
                  final isSelected = spec == _selectedSpecialization;
                  return FilterChip(
                    label: Text(spec),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedSpecialization = selected ? spec : 'Все');
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary,
                    labelStyle: AppTextStyles.body1.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.inputBorder,
                      ),
                    ),
                    checkmarkColor: Colors.white,
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Опыт и цена
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Опыт работы',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: _experiences.map((exp) {
                          final isSelected = exp == _selectedExperience;
                          return FilterChip(
                            label: Text(exp),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedExperience = selected ? exp : 'Любой');
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: AppTextStyles.body1.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.inputBorder,
                              ),
                            ),
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Цена за сессию',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: _prices.map((price) {
                          final isSelected = price == _selectedPrice;
                          return FilterChip(
                            label: Text(price),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedPrice = selected ? price : 'Любая');
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: AppTextStyles.body1.copyWith(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.inputBorder,
                              ),
                            ),
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Опыт работы',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _experiences.map((exp) {
                        final isSelected = exp == _selectedExperience;
                        return FilterChip(
                          label: Text(exp),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedExperience = selected ? exp : 'Любой');
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary,
                          labelStyle: AppTextStyles.body1.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.inputBorder,
                            ),
                          ),
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Цена за сессию',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _prices.map((price) {
                        final isSelected = price == _selectedPrice;
                        return FilterChip(
                          label: Text(price),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedPrice = selected ? price : 'Любая');
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.primary,
                          labelStyle: AppTextStyles.body1.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.inputBorder,
                            ),
                          ),
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 32),
          if (isMobile)
            Center(
              child: CustomButton(
                text: 'Сбросить фильтры',
                onPressed: _resetFilters,
                isPrimary: false,
                isFullWidth: false,
                icon: Icons.refresh,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPsychologistsGrid(bool isMobile, bool isTablet) {
    final filtered = _filteredPsychologists;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 60,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filtered.length} ${_getCorrectWord(filtered.length)}',
                style: AppTextStyles.h2.copyWith(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!isMobile)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filtered.length} из ${_psychologists.length}',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          filtered.isEmpty
              ? _buildEmptyState(isMobile)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                    crossAxisSpacing: isMobile ? 0 : 24,
                    mainAxisSpacing: isMobile ? 24 : 32,
                    childAspectRatio: isMobile ? 1.3 : 0.85,
                    mainAxisExtent: isMobile ? null : 520, // Фиксированная высота для десктопа
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildPsychologistCard(
                      filtered[index],
                      isMobile,
                    );
                  },
                ),
        ],
      ),
    );
  }

  String _getCorrectWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'психолог';
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'психолога';
    }
    return 'психологов';
  }

  Widget _buildEmptyState(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 100,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Психологов не найдено',
            style: AppTextStyles.h3.copyWith(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isMobile ? double.infinity : 400,
            child: Text(
              'Попробуйте изменить фильтры или выбрать другие параметры поиска',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 16 : 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: isMobile ? double.infinity : 200,
            child: CustomButton(
              text: 'Сбросить фильтры',
              onPressed: _resetFilters,
              isPrimary: true,
              isFullWidth: true,
              icon: Icons.refresh,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologistCard(Map<String, dynamic> psychologist, bool isMobile) {
    final isAvailable = psychologist['available'] as bool;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Фото и статус
          SizedBox(
            height: isMobile ? 200 : 220,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    psychologist['photo'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primary.withOpacity(0.05),
                        child: Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 80,
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Бэджы
                Positioned(
                  top: 16,
                  left: 16,
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      if (!isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Занято',
                            style: AppTextStyles.body3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ...(psychologist['tags'] as List<String>).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.body3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                // Рейтинг
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${psychologist['rating']}',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Информация
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          psychologist['name'],
                          style: AppTextStyles.h3.copyWith(
                            fontSize: isMobile ? 20 : 22,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          psychologist['specialization'],
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(
                            psychologist['description'],
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppColors.inputBorder.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.work_history_outlined,
                                      size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    psychologist['experience'],
                                    style: AppTextStyles.body2.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.message_outlined,
                                      size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${psychologist['reviews']} отзывов',
                                    style: AppTextStyles.body2.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'от ${psychologist['price']} ₸',
                                style: AppTextStyles.h3.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'за ${psychologist['sessionDuration']}',
                                style: AppTextStyles.body3.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: CustomButton(
                          text: isAvailable ? 'Записаться' : 'Недоступно',
                          onPressed: isAvailable
                              ? () {
                                  Navigator.pushNamed(
                                    context,
                                    '/psychologists/${psychologist['id']}',
                                  );
                                }
                              : null,
                          isPrimary: isAvailable,
                          isFullWidth: true,
                          icon: isAvailable ? Icons.arrow_forward_rounded : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 60 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.primaryLight.withOpacity(0.08),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Нужна помощь с выбором?',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Наши консультанты помогут подобрать психолога именно под ваш запрос, цели и бюджет. Мы учтем все нюансы и предложим лучших специалистов.',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: isMobile ? 16 : 18,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: isMobile ? 16 : 24,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildBenefitItem('✓ Бесплатная консультация по подбору'),
                    _buildBenefitItem('✓ Подбор по 5+ параметрам'),
                    _buildBenefitItem('✓ Помощь в записи на первую сессию'),
                    _buildBenefitItem('✓ Поддержка на всех этапах'),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: isMobile ? double.infinity : 280,
                  height: 56,
                  child: CustomButton(
                    text: 'Подобрать психолога',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.contacts);
                    },
                    isPrimary: true,
                    isFullWidth: true,
                    icon: Icons.psychology_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}