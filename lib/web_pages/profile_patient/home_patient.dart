// lib/web_pages/profile_patient/home_patient.dart

import 'package:flutter/material.dart';
import '../../../widgets/profile_patient/patient_bar.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_colors.dart';
import '../../../сore/router/app_router.dart';

// УДАЛЯЕМ импорт SessionsCalendarPage отсюда - он уже в app_router.dart
// import 'sessions_calendar.dart';

class HomePatientPage extends StatelessWidget {
  const HomePatientPage({super.key});

  // === СТАТЬИ ===
  List<Map<String, dynamic>> _getFeaturedArticles() {
    final allArticles = _getAllArticles();
    return allArticles.take(4).toList();
  }

  List<Map<String, dynamic>> _getAllArticles() {
    return [
      {
        'title': 'Mindfulness: как практика осознанности меняет мозг',
        'category': 'МЕДИТАЦИЯ',
        'readTime': '10 мин чтения',
        'date': '15 ноября 2024',
        'image': 'assets/images/article/calm.png',
        'color': const Color(0xFFFF6B9D),
        'preview': 'Регулярная практика осознанности перестраивает мозг, снижая стресс и улучшая фокус.',
        'content': '''
# Что такое mindfulness?

Mindfulness — это осознанное пребывание в настоящем моменте без оценки. Это не медитация в лотосе, а навык, который можно тренировать в любой момент: за еды, в транспорте, на встрече.

## Как это работает в мозге?

Нейробиологи из Гарварда провели МРТ-исследования и обнаружили:

- Увеличение серого вещества в гиппокампе — центре памяти и обучения
- Снижение активности миндалины — центра страха и тревоги
- Усиление связей в префронтальной коре — зоне самоконтроля

### Практика 5 минут в день

1. Сядьте удобно
2. Закройте глаза
3. Сфокусируйтесь на дыхании
4. Когда мысли уводят — мягко возвращайтесь

> Уже через 8 недель регулярной практики мозг начинает меняться физически.

### Польза для жизни

- Снижение кортизола на 30%
- Улучшение сна на 40%
- Рост эмпатии и эмоционального интеллекта

Попробуйте прямо сейчас — это бесплатно и доступно каждому.
        ''',
        'featured': true,
      },
      {
        'title': 'Как справляться с тревогой в повседневной жизни',
        'category': 'Эмоции',
        'readTime': '8 мин',
        'date': '12 ноя 2024',
        'image': 'assets/images/article/sad.png',
        'color': const Color(0xFF4A90E2),
        'preview': 'Тревога — это не враг. Это сигнал. Учитесь его понимать и управлять.',
        'content': '''
# Тревога — это нормально

Каждый человек испытывает тревогу. Это защитный механизм, который помогал нашим предкам выживать. Проблема начинается, когда тревога становится хронической.

## Техника "Назови и отпусти"

1. Заметьте тревогу
2. Назови её: "Я чувствую тревогу в груди"
3. Спросите: "Это реальная угроза?"
4. Дайте телу 90 секунд — пик тревоги пройдёт

### Дыхание 4-7-8

- Вдох на 4 счёта
- Задержка на 7
- Выдох на 8

Повторите 4 раза. Это активирует парасимпатическую систему.

> Тревога не может длиться вечно. Она всегда проходит.

### Что делать дальше?

- Двигайтесь — 10 минут прогулки снижают тревогу на 25%
- Пишите — выгрузите мысли на бумагу
- Говорите — поделитесь с близким

Тревога — это не вы. Это временное состояние.
        ''',
        'featured': false,
      },
      {
        'title': 'Техники дыхания для релаксации',
        'category': 'Самопомощь',
        'readTime': '6 мин',
        'date': '10 ноя 2024',
        'image': 'assets/images/article/5min.png',
        'color': const Color(0xFF50E3C2),
        'preview': 'Дыхание — самый быстрый способ успокоить нервную систему.',
        'content': '''
# Дыхание — ваш встроенный антистресс

Когда вы дышите глубоко, вы активируете блуждающий нерв, который замедляет сердцебиение и снижает давление.

## Техника "Коробочное дыхание"

1. Вдох — 4 секунды
2. Задержка — 4 секунды
3. Выдох — 4 секунды
4. Задержка — 4 секунды

Повторите 5 циклов.

### Когда использовать?

- Перед важной встречей
- После конфликта
- При бессоннице
- В пробке

> 3 минуты практики = 30 минут спокойствия.

### Бонус: дыхание "по квадрату"

Представьте квадрат:
- Вверх — вдох
- Вправо — задержка
- Вниз — выдох
- Влево — задержка

Это помогает детям и взрослым с СДВГ.

Дышите осознанно — живите спокойнее.
        ''',
        'featured': false,
      },
      {
        'title': 'Почему мы избегаем конфликтов',
        'category': 'Отношения',
        'readTime': '9 мин',
        'date': '8 ноя 2024',
        'image': 'assets/images/article/dontAgro.png',
        'color': const Color(0xFFF5A623),
        'preview': 'Избегание конфликтов разрушает отношения. Учитесь говорить открыто.',
        'content': '''
# Конфликт — это не плохо

Конфликт — это столкновение потребностей. Избегание его приводит к накоплению обид и дистанции.

## Почему мы боимся?

- Страх быть отвергнутым
- Воспитание: "Хорошие девочки не спорят"
- Прошлый негативный опыт

### Как начать говорить?

1. Используйте "Я-сообщения": "Я чувствую..."
2. Говорите о фактах, не о личности
3. Слушайте, не перебивая

> Здоровый конфликт укрепляет доверие.

### Пример диалога

Вместо: "Ты никогда не помогаешь!"
Скажите: "Я чувствую себя перегруженной, когда убираюсь одна. Давай распределим обязанности?"

Конфликт — это мост к пониманию.
        ''',
        'featured': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фиксированный сайдбар, который не скролится
          Container(
            width: 280,
            child: PatientBar(currentRoute: AppRouter.dashboard),
          ),
          // Основной контент с возможностью скролла
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                margin: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _buildWelcomeCard(context),
                              const SizedBox(height: 24),
                              _buildUpcomingSession(context),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: _buildQuickActions(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildArticlesSection(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === ЗАГОЛОВОК ===
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Добро пожаловать!', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Пятница, 1 ноября',
                    style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderAction(context, Icons.notifications_outlined, 'Уведомления', _showNotifications),
              const SizedBox(width: 12),
              _buildHeaderAction(context, Icons.help_outline, 'Помощь', _showHelp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(BuildContext context, IconData icon, String label, Function(BuildContext) onTap) {
    return Material(
      color: AppColors.primaryLight.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onTap(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === КАРТОЧКА ПРИВЕТСТВИЯ ===
  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Как ваше самочувствие сегодня?',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Пройдите быстрый тест и получите персонализированные рекомендации',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const MoodAssessmentPage(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Text(
                    'Оценить настроение',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.psychology_outlined, size: 48, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // === БЫСТРЫЕ ДЕЙСТВИЯ ===
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.video_call,
        'title': 'Мои сессии',
        'subtitle': 'Запланировать встречу',
        'color': AppColors.primary,
        'onTap': () => _showSessionsCalendar(context),
      },
      {
        'icon': Icons.assignment,
        'title': 'Дневник',
        'subtitle': 'Записать мысли',
        'color': const Color(0xFFFF6B9D),
        'onTap': () => _showComingSoon(context, 'Дневник'),
      },
      {
        'icon': Icons.insights,
        'title': 'Прогресс',
        'subtitle': 'Посмотреть статистику',
        'color': const Color(0xFF4CAF50),
        'onTap': () => _showComingSoon(context, 'Прогресс'),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.shadow.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Быстрые действия', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          ...actions.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildQuickActionItem(
                  context,
                  action['icon'] as IconData,
                  action['title'] as String,
                  action['subtitle'] as String,
                  action['color'] as Color,
                  action['onTap'] as Function,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    Function onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }

  // === КАЛЕНДАРЬ ===
  void _showSessionsCalendar(BuildContext context) {
    // Используем навигацию через AppRouter вместо прямого импорта
    AppRouter.navigateTo(context, AppRouter.sessionsCalendar);
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - скоро будет доступно'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // === БЛИЖАЙШИЕ СЕССИИ ===
  Widget _buildUpcomingSession(BuildContext context) {
    final sessions = [
      {'date': DateTime.now().add(const Duration(days: 1)), 'time': '15:30', 'psychologist': 'Diana', 'avatar': 'assets/images/avatar/diana.png', 'type': 'Видео-сессия', 'status': 'Подтверждено'},
      {'date': DateTime.now().add(const Duration(days: 5)), 'time': '14:00', 'psychologist': 'Laura', 'avatar': 'assets/images/avatar/laura2.png', 'type': 'Аудио-сессия', 'status': 'Ожидает'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ближайшие сессии', style: AppTextStyles.h3),
              TextButton.icon(
                onPressed: () => _showSessionsCalendar(context),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('Календарь', style: AppTextStyles.body2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Предстоящие', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...sessions.map((session) => _buildSessionItem(session)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showNewSessionDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Запланировать новую сессию', style: AppTextStyles.button.copyWith(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
          _buildCalendarSection(sessions),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(List<Map<String, dynamic>> sessions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ноябрь 2024', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildCalendarGrid(sessions),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<Map<String, dynamic>> sessions) {
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    final today = DateTime.now();

    final moods = <DateTime, MoodModel>{
      today.subtract(const Duration(days: 2)): MoodModel(
        id: '2',
        name: 'Радость',
        emoji: 'positive',
        imagePath: 'assets/images/mood/mood_happy.png',
        description: 'Чувствую себя хорошо и позитивно',
        color: const Color(0xFF4CAF50),
      ),
      today.subtract(const Duration(days: 1)): MoodModel(
        id: '3',
        name: 'Спокойствие',
        emoji: 'neutral',
        imagePath: 'assets/images/mood/mood_neutral.png',
        description: 'Внутренняя гармония и баланс',
        color: const Color(0xFF2196F3),
      ),
      today: MoodModel(
        id: '4',
        name: 'Грусть',
        emoji: 'negative',
        imagePath: 'assets/images/mood/mood_sad.png',
        description: 'Чувствую легкую печаль',
        color: const Color(0xFF607D8B),
      ),
      today.add(const Duration(days: 3)): MoodModel(
        id: '1',
        name: 'Эйфория',
        emoji: 'overjoyed',
        imagePath: 'assets/images/mood/mood_overjoyed.png',
        description: 'Отличное настроение! Полон энергии и радости',
        color: const Color(0xFFFFD700),
      ),
    };

    final diaryEntries = <DateTime, List<String>>{
      today.subtract(const Duration(days: 2)): ['Сегодня был отличный день!', 'Встретился с друзьями.'],
      today: ['Чувствую усталость после работы.', 'Нужно отдохнуть.'],
      today.add(const Duration(days: 3)): ['Планирую поездку на выходные.'],
    };

    return Column(
      children: [
        Row(
          children: days.map((day) => Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ),
          )).toList(),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: 35,
          itemBuilder: (context, index) {
            final firstDayOfMonth = DateTime(today.year, today.month, 1);
            final startingWeekday = firstDayOfMonth.weekday;
            if (index < startingWeekday - 1) {
              return const SizedBox.shrink();
            }

            final day = index - startingWeekday + 2;
            final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
            if (day < 1 || day > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(today.year, today.month, day);
            final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
            final mood = moods[date];
            final hasDiary = diaryEntries.containsKey(date);
            final hasSession = sessions.any((s) =>
                (s['date'] as DateTime).day == day &&
                (s['date'] as DateTime).month == today.month);

            return GestureDetector(
              onTap: () => _showDayDetails(context, date, mood, diaryEntries[date]),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isToday ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? AppColors.primary : AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 3,
                      runSpacing: 2,
                      children: [
                        if (hasSession)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                        if (mood != null)
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: mood.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(color: mood.color.withOpacity(0.3), width: 1),
                            ),
                            child: Center(
                              child: Image.asset(mood.imagePath, width: 12, height: 12, fit: BoxFit.contain),
                            ),
                          ),
                        if (hasDiary)
                          const Icon(Icons.note_alt_outlined, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showDayDetails(BuildContext context, DateTime date, MoodModel? mood, List<String>? entries) {
    final formattedDate = _formatDate(date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(formattedDate, style: AppTextStyles.h3),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailSection(
                  'Настроение',
                  mood != null
                      ? Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: mood.color.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Image.asset(mood.imagePath, width: 32, height: 32)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(mood.name, style: AppTextStyles.body1.copyWith(color: mood.color, fontWeight: FontWeight.w600)),
                                  Text(mood.description, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Text('Не оценивалось', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 16),
                _buildDetailSection(
                  'Записи в дневнике',
                  entries != null && entries.isNotEmpty
                      ? Column(
                          children: entries.map((e) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(e, style: AppTextStyles.body2),
                          )).toList(),
                        )
                      : Text('Нет записей', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть', style: AppTextStyles.body1.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundImage: AssetImage(session['avatar'])),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session['psychologist'], style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${_formatDate(session['date'] as DateTime)} • ${session['time']} • ${session['type']}', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(session['status'], style: AppTextStyles.body3.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // === ДИАЛОГИ ===
  void _showNewSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Запланировать сессию', style: AppTextStyles.h2),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFormField('Выберите психолога', Icons.person),
                const SizedBox(height: 16),
                _buildFormField('Выберите дату', Icons.calendar_today),
                const SizedBox(height: 16),
                _buildFormField('Выберите время', Icons.access_time),
                const SizedBox(height: 16),
                _buildFormField('Тип сессии', Icons.video_call),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Отмена', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Сессия успешно запланирована'), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Запланировать', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String hint, IconData icon) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inputBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inputBorder)),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [Icon(Icons.notifications, color: AppColors.primary), const SizedBox(width: 12), Text('Уведомления', style: AppTextStyles.h2)]),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNotificationItem('Новая сессия', 'У вас запланирована сессия с психологом сегодня в 15:30', Icons.event_available, AppColors.primary),
                const SizedBox(height: 12),
                _buildNotificationItem('Напоминание', 'Не забудьте заполнить дневник настроения', Icons.assignment, const Color(0xFFFF6B9D)),
                const SizedBox(height: 12),
                _buildNotificationItem('Новая статья', 'Доступна новая статья о техниках релаксации', Icons.article, const Color(0xFF4CAF50)),
              ],
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрыть', style: AppTextStyles.body1.copyWith(color: AppColors.primary)))],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, size: 20, color: color)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(message, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary))])),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [Icon(Icons.help_outline, color: AppColors.primary), const SizedBox(width: 12), Text('Помощь', style: AppTextStyles.h2)]),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Часто задаваемые вопросы:', style: AppTextStyles.h3),
                const SizedBox(height: 16),
                _buildHelpItem('Как записаться на сессию?', 'Перейдите в раздел "Мои сессии" и выберите удобное время'),
                _buildHelpItem('Где найти дневник настроения?', 'Дневник доступен в разделе "Быстрые действия" на главной странице'),
                _buildHelpItem('Как связаться с психологом?', 'Используйте чат в разделе "Мои сессии" для общения с вашим психологом'),
                _buildHelpItem('Техническая поддержка', 'По вопросам работы приложения обращайтесь: support@balancepsy.ru'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрыть', style: AppTextStyles.body1.copyWith(color: AppColors.primary))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showContactSupport(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Связаться с поддержкой', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(answer, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Связаться с поддержкой', style: AppTextStyles.h2),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Выберите удобный способ связи:', style: AppTextStyles.body1),
                const SizedBox(height: 16),
                _buildContactMethod('Email', 'support@balancepsy.ru', Icons.email, context),
                _buildContactMethod('Телефон', '+7 (999) 123-45-67', Icons.phone, context),
                _buildContactMethod('Telegram', '@balancepsy_support', Icons.send, context),
              ],
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрыть', style: AppTextStyles.body1.copyWith(color: AppColors.primary)))],
      ),
    );
  }

  Widget _buildContactMethod(String method, String contact, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _showComingSoon(context, 'Контакт: $method'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(method, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)), Text(contact, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary))])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === СТАТЬИ ===
  Widget _buildArticlesSection(BuildContext context) {
    final articles = _getFeaturedArticles();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Рекомендуемые статьи', style: AppTextStyles.h3),
            TextButton(
              onPressed: () {
                AppRouter.navigateTo(context, AppRouter.patientArticles);
              },
              child: Text('Смотреть все', style: AppTextStyles.body2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.8, mainAxisSpacing: 24, crossAxisSpacing: 24),
          itemCount: articles.length,
          itemBuilder: (context, index) => _buildArticleCard(articles[index], context),
        ),
      ],
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) {
                return Scaffold(
                  body: Row(
                    children: [
                      Container(
                        width: 280,
                        child: PatientBar(currentRoute: AppRouter.patientArticles),
                      ),
                      Expanded(
                        child: ArticleReaderPage(article: article),
                      ),
                    ],
                  ),
                );
              },
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  image: DecorationImage(image: AssetImage(article['image']), fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: (article['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(article['category'], style: AppTextStyles.body3.copyWith(color: article['color'], fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 12),
                    Text(article['title'], style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w700, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(children: [Icon(Icons.access_time, size: 14, color: AppColors.textSecondary), const SizedBox(width: 6), Text(article['readTime'], style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary))]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Класс для модели настроения
class MoodModel {
  final String id;
  final String name;
  final String emoji;
  final String imagePath;
  final String description;
  final Color color;

  MoodModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.imagePath,
    required this.description,
    required this.color,
  });
}

// Класс для страницы чтения статьи (добавляем в конец файла)
class ArticleReaderPage extends StatefulWidget {
  final Map<String, dynamic> article;
  const ArticleReaderPage({super.key, required this.article});

  @override
  State<ArticleReaderPage> createState() => _ArticleReaderPageState();
}

class _ArticleReaderPageState extends State<ArticleReaderPage> {
  final ScrollController _scrollController = ScrollController();
  double _readingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      setState(() => _readingProgress = (current / max).clamp(0.0, 1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6, child: LinearProgressIndicator(value: _readingProgress, backgroundColor: AppColors.inputBackground, valueColor: AlwaysStoppedAnimation(widget.article['color'] as Color))),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: (widget.article['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Text(widget.article['category'] as String, style: AppTextStyles.body1.copyWith(color: widget.article['color'] as Color, fontWeight: FontWeight.w700, fontSize: 14))),
                        const SizedBox(height: 20),
                        Text(widget.article['title'] as String, style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w700, height: 1.2, fontSize: 38)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(widget.article['readTime'] as String, style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
                            const SizedBox(width: 24),
                            Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(widget.article['date'] as String, style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))]),
                    child: _buildArticleContent(widget.article['content'] as String),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.inputBorder))),
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: Text('Назад', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _shareArticle(context),
                        style: ElevatedButton.styleFrom(backgroundColor: widget.article['color'] as Color, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        icon: const Icon(Icons.share, color: Colors.white, size: 18),
                        label: Text('Поделиться', style: AppTextStyles.body1.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleContent(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('# ')) {
          return Padding(padding: const EdgeInsets.only(top: 28, bottom: 14), child: Text(line.substring(2), style: AppTextStyles.h1.copyWith(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textPrimary)));
        } else if (line.startsWith('## ')) {
          return Padding(padding: const EdgeInsets.only(top: 22, bottom: 10), child: Text(line.substring(3), style: AppTextStyles.h2.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)));
        } else if (line.startsWith('### ')) {
          return Padding(padding: const EdgeInsets.only(top: 18, bottom: 8), child: Text(line.substring(4), style: AppTextStyles.h3.copyWith(fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.textPrimary)));
        } else if (line.startsWith('- ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 7, right: 10), child: Container(width: 5, height: 5, decoration: BoxDecoration(color: widget.article['color'] as Color, shape: BoxShape.circle))),
                Expanded(child: Text(line.substring(2), style: AppTextStyles.body1.copyWith(fontSize: 15.5, height: 1.55, color: AppColors.textPrimary))),
              ],
            ),
          );
        } else if (line.trim().isEmpty) {
          return const SizedBox(height: 14);
        } else if (line.startsWith('> ')) {
          return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(line.substring(2), style: AppTextStyles.body1.copyWith(fontSize: 16, height: 1.6, fontStyle: FontStyle.italic, color: AppColors.textSecondary)));
        } else {
          return Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Text(line, style: AppTextStyles.body1.copyWith(fontSize: 15.5, height: 1.55, color: AppColors.textPrimary)));
        }
      }).toList(),
    );
  }

  void _shareArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Поделиться статьей', style: AppTextStyles.h2),
        content: Text('Ссылка скопирована в буфер обмена!', style: AppTextStyles.body1),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрыть', style: AppTextStyles.body1.copyWith(color: AppColors.primary)))],
      ),
    );
  }
}

// Импорт для MoodAssessmentPage - нужно создать отдельный файл или оставить заглушку
class MoodAssessmentPage extends StatelessWidget {
  const MoodAssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Center(
        child: Text(
          'Оценка настроения',
          style: AppTextStyles.h2,
        ),
      ),
    );
  }
}