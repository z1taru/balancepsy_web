// lib/web_pages/psychologists/psychologist_detail.dart
import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class PsychologistDetail extends StatefulWidget {
  final String id;
  const PsychologistDetail({super.key, required this.id});

  @override
  State<PsychologistDetail> createState() => _PsychologistDetailState();
}

class _PsychologistDetailState extends State<PsychologistDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  late Map<String, dynamic> _psychologist;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPsychologist();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPsychologist() {
    final psychologists = {
      '1': {
        'name': 'Галия Аубакирова',
        'photo': 'assets/images/main_page/galiya1.png',
        'specialization': 'Когнитивно-поведенческая терапия',
        'experience': '8 лет',
        'rating': 4.9,
        'reviews': 127,
        'price': '15 000',
        'education': 'КазНУ им. Аль-Фараби, психология',
        'certificates': ['КПТ-терапевт', 'Гештальт-терапия', 'Trauma-focused CBT'],
        'helps': ['Тревожность', 'Депрессия', 'Панические атаки', 'ОКР', 'Фобии'],
        'description': 'Помогаю справиться с тревожностью, депрессией и паническими атаками. Работаю в подходе когнитивно-поведенческой терапии. За годы практики помогла более 200 клиентам обрести внутренний баланс и научиться управлять своими эмоциями.',
        'languages': ['Русский', 'Казахский', 'Английский'],
        'sessionDuration': '50 минут',
        'about': 'Я практикующий психолог с 8-летним опытом работы. Окончила КазНУ им. Аль-Фараби по специальности "Клиническая психология". Прошла дополнительное обучение по когнитивно-поведенческой терапии в Институте КПТ (Москва). \n\nМоя основная специализация - работа с тревожными расстройствами, депрессией и паническими атаками. Использую научно обоснованные методы, доказавшие свою эффективность.\n\nВерю, что каждый человек способен изменить свою жизнь к лучшему, если получит правильную поддержку и инструменты для работы над собой.',
        'approach': 'В своей работе я использую когнитивно-поведенческую терапию (КПТ) - один из наиболее изученных и эффективных методов психотерапии. КПТ помогает:\n\n• Распознать негативные мысли и убеждения\n• Изменить деструктивные паттерны поведения\n• Разработать здоровые стратегии совладания\n• Достичь устойчивых изменений\n\nТакже интегрирую элементы гештальт-терапии для работы с незавершенными ситуациями и эмоциями.',
        'format': 'Консультации проходят онлайн в удобное для вас время. Для сессий использую защищенную платформу с видеосвязью.\n\nПервая встреча - это знакомство, где мы:\n• Обсудим ваш запрос\n• Определим цели терапии\n• Составим план работы\n• Ответим на все ваши вопросы\n\nРегулярность встреч обсуждается индивидуально, обычно рекомендую еженедельные сессии.',
        'reviewsList': [
          {
            'name': 'Анна К.',
            'rating': 5,
            'date': '2 недели назад',
            'text': 'Галия помогла мне справиться с паническими атаками, которые мучили меня несколько лет. После 3 месяцев работы я снова чувствую себя полноценным человеком. Очень благодарна!'
          },
          {
            'name': 'Дмитрий М.',
            'rating': 5,
            'date': '1 месяц назад',
            'text': 'Профессиональный подход, четкие рекомендации. Галия не просто слушает, а дает конкретные инструменты для работы над собой.'
          },
          {
            'name': 'Елена С.',
            'rating': 4,
            'date': '2 месяца назад',
            'text': 'Хороший специалист, помогла разобраться с причинами моей тревожности. Работаем уже 2 месяца, вижу прогресс.'
          },
        ],
      },
      '2': {
        'name': 'Яна Прозорова',
        'photo': 'assets/images/main_page/yana1.png',
        'specialization': 'Семейная и парная терапия',
        'experience': '10 лет',
        'rating': 5.0,
        'reviews': 203,
        'price': '18 000',
        'education': 'МГУ им. Ломоносова, клиническая психология',
        'certificates': ['Семейный психолог', 'Эмоционально-фокусированная терапия', 'Системная терапия'],
        'helps': ['Отношения', 'Семейные конфликты', 'Развод', 'Измена', 'Коммуникация'],
        'description': 'Специализируюсь на работе с парами и семьями. Помогаю восстановить близость и найти взаимопонимание в отношениях.',
        'languages': ['Русский', 'Английский'],
        'sessionDuration': '60 минут',
        'about': 'Имею 10-летний опыт работы с парами и семьями. Окончила МГУ им. Ломоносова, защитила кандидатскую диссертацию по семейной психологии.\n\nПомогаю парам преодолеть кризисы, восстановить доверие и близость. Работаю как с супружескими парами, так и с партнерами на разных стадиях отношений.',
        'approach': 'Использую эмоционально-фокусированную терапию (ЭФТ) и системный подход. Эти методы признаны наиболее эффективными для работы с парами.\n\nВ процессе терапии мы:\n• Выявляем негативные паттерны взаимодействия\n• Учимся безопасно выражать свои потребности\n• Восстанавливаем эмоциональную связь\n• Развиваем навыки конструктивной коммуникации',
        'format': 'Работаю как с парами, так и индивидуально. Сессии длятся 60 минут. Рекомендую еженедельные встречи на начальном этапе.\n\nПервая консультация - это возможность понять, подходим ли мы друг другу и какой будет план работы.',
        'reviewsList': [
          {
            'name': 'Марина и Андрей',
            'rating': 5,
            'date': '1 неделя назад',
            'text': 'Яна спасла наш брак! После 10 лет совместной жизни мы были на грани развода. Благодаря терапии мы снова стали близки и научились слышать друг друга.'
          },
          {
            'name': 'Ольга Р.',
            'rating': 5,
            'date': '3 недели назад',
            'text': 'Очень деликатный и профессиональный подход. Яна создает безопасное пространство для обоих партнеров.'
          },
        ],
      },
      '3': {
        'name': 'Лаура Болдина',
        'photo': 'assets/images/main_page/laura1.png',
        'specialization': 'Психотерапия самооценки',
        'experience': '7 лет',
        'rating': 4.8,
        'reviews': 95,
        'price': '14 000',
        'education': 'НИУ ВШЭ, психология личности',
        'certificates': ['Позитивная психотерапия', 'Арт-терапия', 'Экзистенциальная терапия'],
        'helps': ['Самооценка', 'Уверенность в себе', 'Самопознание', 'Кризис идентичности'],
        'description': 'Работаю с вопросами самооценки, помогаю обрести уверенность и найти себя.',
        'languages': ['Русский', 'Казахский'],
        'sessionDuration': '50 минут',
        'about': 'Я психолог с 7-летним опытом, специализируюсь на вопросах самооценки и самопознания. Помогаю людям обрести уверенность в себе и найти свой путь.\n\nИспользую интегративный подход, сочетая позитивную психотерапию, арт-терапию и экзистенциальные методы.',
        'approach': 'Мой подход основан на убеждении, что внутри каждого человека есть ресурсы для роста и развития. Моя задача - помочь вам их обнаружить и активировать.\n\nВ работе использую:\n• Позитивную психотерапию\n• Арт-терапевтические техники\n• Практики осознанности\n• Работу с внутренним критиком',
        'format': 'Консультации проходят онлайн, длительность 50 минут. Иногда использую творческие задания и практики между сессиями.\n\nПервая встреча бесплатная - это возможность познакомиться и понять, подходим ли мы друг другу.',
        'reviewsList': [
          {
            'name': 'Айгуль Т.',
            'rating': 5,
            'date': '2 недели назад',
            'text': 'Лаура помогла мне поверить в себя. Теперь я не боюсь проявлять себя и отстаивать свои границы.'
          },
        ],
      },
    };

    _psychologist = psychologists[widget.id] ?? psychologists['1']!;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.psychologists,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(isMobile, isTablet),
            _buildMainInfo(isMobile, isTablet),
            _buildTabs(isMobile, isTablet),
            _buildTabContent(isMobile, isTablet),
            _buildBookingSection(isMobile, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    return Container(
      height: isMobile ? 320 : 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_psychologist['photo']),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40,
            left: isMobile ? 20 : 80,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _psychologist['name'],
                  style: AppTextStyles.h1.copyWith(
                    fontSize: isMobile ? 32 : 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _psychologist['specialization'],
                  style: AppTextStyles.body1.copyWith(
                    fontSize: isMobile ? 18 : 24,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfo(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      child: Column(
        children: [
          Text(
            _psychologist['description'],
            style: AppTextStyles.body1.copyWith(
              fontSize: isMobile ? 16 : 18,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: isMobile ? 16 : 32,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildInfoCard(
                Icons.star_rounded,
                '${_psychologist['rating']}',
                '${_psychologist['reviews']} отзывов',
                isMobile,
              ),
              _buildInfoCard(
                Icons.work_history_rounded,
                _psychologist['experience'],
                'Практики',
                isMobile,
              ),
              _buildInfoCard(
                Icons.language_rounded,
                '${_psychologist['languages'].length}',
                'Языков',
                isMobile,
              ),
              _buildInfoCard(
                Icons.timer_rounded,
                _psychologist['sessionDuration'],
                'На сессию',
                isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label, bool isMobile) {
    return Container(
      width: isMobile ? 140 : 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isMobile, bool isTablet) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : (isTablet ? 40 : 80)),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: AppTextStyles.body1.copyWith(fontSize: 16),
        tabs: const [
          Tab(text: 'О специалисте'),
          Tab(text: 'Образование'),
          Tab(text: 'Отзывы'),
        ],
      ),
    );
  }

  Widget _buildTabContent(bool isMobile, bool isTablet) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      child: SizedBox(
        height: 600, // Добавил фиксированную высоту для лучшей пропорциональности
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAboutTab(isMobile),
            _buildEducationTab(isMobile),
            _buildReviewsTab(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab(bool isMobile) {
    return ListView(
      children: [
        _buildSectionTitle('О себе'),
        const SizedBox(height: 16),
        Text(
          _psychologist['about'],
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Подход в работе'),
        const SizedBox(height: 16),
        Text(
          _psychologist['approach'],
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Формат работы'),
        const SizedBox(height: 16),
        Text(
          _psychologist['format'],
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('С чем работаю'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: (_psychologist['helps'] as List<String>).map((help) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                help,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Языки консультаций'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: (_psychologist['languages'] as List<String>).map((lang) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
              ),
              child: Text(
                lang,
                style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEducationTab(bool isMobile) {
    return ListView(
      children: [
        _buildSectionTitle('Образование'),
        const SizedBox(height: 16),
        _buildEducationCard(_psychologist['education'], isMobile),
        const SizedBox(height: 32),
        _buildSectionTitle('Сертификаты и квалификации'),
        const SizedBox(height: 16),
        ...(_psychologist['certificates'] as List<String>).map(
          (cert) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCertificateCard(cert, isMobile),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationCard(String education, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              education,
              style: AppTextStyles.body1.copyWith(
                fontSize: isMobile ? 16 : 18,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(String certificate, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              certificate,
              style: AppTextStyles.body1.copyWith(fontSize: isMobile ? 16 : 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(bool isMobile) {
    final reviews = _psychologist['reviewsList'] as List<Map<String, dynamic>>;
    
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                '${_psychologist['rating']}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < _psychologist['rating'].floor()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppColors.warning,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${_psychologist['reviews']} реальных отзывов',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ...reviews.map((review) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildReviewCard(review, isMobile),
            )),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['name'],
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                review['date'],
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review['rating'] ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.warning,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            review['text'],
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontSize: isMobile ? 16 : 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection(bool isMobile, bool isTablet) {
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
            AppColors.primaryLight.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Готовы начать путь к балансу?',
            style: AppTextStyles.h2.copyWith(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Запишитесь на первую консультацию и сделайте шаг к лучшей версии себя. ${_psychologist['name']} поможет вам в этом.',
            style: AppTextStyles.body1.copyWith(
              fontSize: isMobile ? 16 : 18,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'от ${_psychologist['price']} ₸ / ${_psychologist['sessionDuration']}',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 24,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: isMobile ? double.infinity : 320,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'Записаться на консультацию',
                style: AppTextStyles.body1.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}