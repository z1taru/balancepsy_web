// lib/web_pages/profile_patient/home_patient.dart

import 'package:flutter/material.dart';
import '../../../../../widgets/profile_patient/patient_bar.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../сore/router/app_router.dart';
import '../../../../../сore/services/profile_patient_service.dart';
import '../../../../../web_pages/services/psychologist_service.dart';
import 'package:provider/provider.dart';
import '../../../../../web_pages/services/user_provider.dart';

class HomePatientPage extends StatefulWidget {
  const HomePatientPage({super.key});

  @override
  State<HomePatientPage> createState() => _HomePatientPageState();
}

class _HomePatientPageState extends State<HomePatientPage> {
  final ProfilePatientService _profileService = ProfilePatientService();
  final PsychologistService _psychologistService = PsychologistService();

  bool _isLoading = true;
  String? _error;

  // Данные
  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Загружаем записи и статьи параллельно
      final results = await Future.wait([
        _psychologistService.getMyAppointments(),
        _profileService.getArticles(limit: 4),
      ]);

      setState(() {
        _appointments = results[0];
        _articles = results[1];
        _isLoading = false;
      });

      print(
        '✅ Loaded ${_appointments.length} appointments and ${_articles.length} articles',
      );
    } catch (e) {
      print('❌ Error loading data: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280,
            child: PatientBar(currentRoute: AppRouter.dashboard),
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _error != null
                ? _buildErrorState()
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Загрузка данных...', style: AppTextStyles.body1),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Ошибка загрузки данных', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(_error ?? '', style: AppTextStyles.body1),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Попробовать снова', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
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
                Expanded(flex: 2, child: _buildQuickActions(context)),
              ],
            ),
            const SizedBox(height: 40),
            _buildArticlesSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

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
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(DateTime.now()),
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderAction(
                context,
                Icons.notifications_outlined,
                'Уведомления',
                _showNotifications,
              ),
              const SizedBox(width: 12),
              _buildHeaderAction(
                context,
                Icons.help_outline,
                'Помощь',
                _showHelp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(
    BuildContext context,
    IconData icon,
    String label,
    Function(BuildContext) onTap,
  ) {
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

  Widget _buildWelcomeCard(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'Пользователь';

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
                  'Здравствуйте, $userName!',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Как ваше самочувствие сегодня? Пройдите быстрый тест и получите персонализированные рекомендации',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.psychology_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Быстрые действия', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildQuickActionItem(
                context,
                action['icon'] as IconData,
                action['title'] as String,
                action['subtitle'] as String,
                action['color'] as Color,
                action['onTap'] as Function,
              ),
            ),
          ),
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
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSession(BuildContext context) {
    // Фильтруем только предстоящие записи (PENDING, CONFIRMED)
    final upcomingSessions = _appointments.where((apt) {
      final status = apt['status']?.toString() ?? '';
      return status == 'PENDING' || status == 'CONFIRMED';
    }).toList();

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
                label: Text(
                  'Календарь',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (upcomingSessions.isEmpty)
            _buildEmptySessionsState()
          else ...[
            Text(
              'Предстоящие',
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...upcomingSessions
                .take(2)
                .map((session) => _buildSessionItem(session)),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showComingSoon(context, 'Новая сессия'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Запланировать новую сессию',
                style: AppTextStyles.button.copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySessionsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Нет предстоящих сессий',
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Запланируйте консультацию с психологом',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    final psychologistName = session['psychologistName'] ?? 'Психолог';
    final date = session['appointmentDate'] ?? '';
    final startTime = session['startTime'] ?? '';
    final status = session['status'] ?? 'PENDING';
    final format = session['format'] ?? 'VIDEO';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  psychologistName,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date • $startTime • ${_getFormatText(format)}',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _getStatusText(status),
              style: AppTextStyles.body3.copyWith(
                color: _getStatusColor(status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormatText(String format) {
    switch (format) {
      case 'VIDEO':
        return 'Видео';
      case 'AUDIO':
        return 'Аудио';
      case 'CHAT':
        return 'Чат';
      default:
        return format;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDING':
        return 'Ожидает';
      case 'CONFIRMED':
        return 'Подтверждено';
      case 'IN_PROGRESS':
        return 'В процессе';
      case 'COMPLETED':
        return 'Завершено';
      case 'CANCELLED':
        return 'Отменено';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return AppColors.primary;
      case 'IN_PROGRESS':
        return Colors.green;
      case 'COMPLETED':
        return Colors.grey;
      case 'CANCELLED':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildArticlesSection(BuildContext context) {
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
              child: Text(
                'Смотреть все',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (_articles.isEmpty)
          _buildEmptyArticlesState()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
            itemCount: _articles.length,
            itemBuilder: (context, index) =>
                _buildArticleCard(_articles[index], context),
          ),
      ],
    );
  }

  Widget _buildEmptyArticlesState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text('Статьи не найдены', style: AppTextStyles.body1),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article, BuildContext context) {
    final title = article['title'] ?? 'Без названия';
    final category = article['category'] ?? 'other';
    final readTime = article['readTime']?.toString() ?? '5';
    final thumbnailUrl = article['thumbnailUrl'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final slug = article['slug'];
          if (slug != null) {
            AppRouter.navigateTo(context, '/articles/$slug');
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: _getCategoryColor(category).withOpacity(0.1),
                ),
                child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          thumbnailUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.article,
                                size: 48,
                                color: _getCategoryColor(
                                  category,
                                ).withOpacity(0.3),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.article,
                          size: 48,
                          color: _getCategoryColor(category).withOpacity(0.3),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryText(category),
                        style: AppTextStyles.body3.copyWith(
                          color: _getCategoryColor(category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$readTime мин чтения',
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'emotions':
        return const Color(0xFF4A90E2);
      case 'self_help':
        return const Color(0xFF50E3C2);
      case 'relationships':
        return const Color(0xFFF5A623);
      case 'stress':
        return const Color(0xFFE56B6F);
      default:
        return AppColors.primary;
    }
  }

  String _getCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'emotions':
        return 'Эмоции';
      case 'self_help':
        return 'Самопомощь';
      case 'relationships':
        return 'Отношения';
      case 'stress':
        return 'Стресс';
      default:
        return 'Другое';
    }
  }

  void _showSessionsCalendar(BuildContext context) {
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

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications, color: AppColors.primary),
            const SizedBox(width: 12),
            Text('Уведомления', style: AppTextStyles.h2),
          ],
        ),
        content: const SizedBox(
          width: 400,
          child: Text('У вас нет новых уведомлений'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Закрыть',
              style: AppTextStyles.body1.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: AppColors.primary),
            const SizedBox(width: 12),
            Text('Помощь', style: AppTextStyles.h2),
          ],
        ),
        content: const SizedBox(
          width: 500,
          child: Text('Здесь будет справочная информация'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Закрыть',
              style: AppTextStyles.body1.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    const weekdays = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}

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
      child: Center(child: Text('Оценка настроения', style: AppTextStyles.h2)),
    );
  }
}
