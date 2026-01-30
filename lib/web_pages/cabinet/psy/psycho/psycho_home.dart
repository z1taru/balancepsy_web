// lib/web_pages/cabinet/psy/psycho/psycho_home.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/unified_sidebar.dart';
import '../../../../core/services/psychologist_api_service.dart';
import '../../../../core/router/app_router.dart';

class PsyHome extends StatefulWidget {
  const PsyHome({super.key});

  @override
  State<PsyHome> createState() => _PsyHomeState();
}

class _PsyHomeState extends State<PsyHome> {
  final PsychologistApiService _apiService = PsychologistApiService();

  bool _isLoading = true;
  bool _localeInitialized = false;
  List<Map<String, dynamic>> _upcomingSessions = [];
  List<Map<String, dynamic>> _newRequests = [];
  List<Map<String, dynamic>> _unreadMessages = [];
  Map<String, dynamic>? _statistics;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeLocaleAndLoadData();
  }

  Future<void> _initializeLocaleAndLoadData() async {
    // ✅ Инициализируем locale для DateFormat
    if (!_localeInitialized) {
      try {
        await initializeDateFormatting('ru', null);
        _localeInitialized = true;
        print('✅ Locale initialized');
      } catch (e) {
        print('⚠️ Locale init failed: $e');
      }
    }

    await _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ✅ Загружаем данные с обработкой ошибок для каждого endpoint
      List<Map<String, dynamic>> sessions = [];
      List<Map<String, dynamic>> requests = [];
      List<Map<String, dynamic>> messages = [];
      Map<String, dynamic>? stats;

      // Предстоящие сессии
      try {
        sessions = await _apiService.getUpcomingSessions();
        print('✅ Loaded ${sessions.length} sessions');
      } catch (e) {
        print('⚠️ Sessions not available: $e');
        // Игнорируем, endpoint может быть не реализован
      }

      // Новые заявки
      try {
        requests = await _apiService.getNewRequests();
        print('✅ Loaded ${requests.length} requests');
      } catch (e) {
        print('⚠️ Requests not available: $e');
      }

      // Непрочитанные сообщения
      try {
        messages = await _apiService.getUnreadMessages();
        print('✅ Loaded ${messages.length} messages');
      } catch (e) {
        print('⚠️ Messages not available: $e');
      }

      // Статистика
      try {
        stats = await _apiService.getStatistics();
        print('✅ Statistics loaded');
      } catch (e) {
        print('⚠️ Statistics not available: $e');
        // Используем моковую статистику
        stats = {
          'sessionStats': {'totalCompletedSessions': 0},
          'clientStats': {'activeClients': 0},
          'ratingStats': {'averageRating': 0.0},
        };
      }

      setState(() {
        _upcomingSessions = sessions;
        _newRequests = requests;
        _unreadMessages = messages;
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Critical error loading dashboard: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Не удалось загрузить данные. Попробуйте позже.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          UnifiedSidebar(currentRoute: AppRouter.psychoDashboard),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _errorMessage != null
                ? _buildErrorState()
                : RefreshIndicator(
                    onRefresh: _loadDashboardData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          if (_newRequests.isNotEmpty) ...[
                            _buildNewRequestsSection(),
                            const SizedBox(height: 24),
                          ],
                          _buildUpcomingSessionsSection(),
                          const SizedBox(height: 24),
                          _buildQuickStatsSection(),
                          const SizedBox(height: 24),
                          if (_unreadMessages.isNotEmpty) ...[
                            _buildUnreadMessagesSection(),
                            const SizedBox(height: 24),
                          ],
                          _buildQuickActionsSection(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text('Загрузка...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text('Ошибка загрузки', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Неизвестная ошибка',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Попробовать снова'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();

    // ✅ Безопасное форматирование даты
    String formattedDate;
    try {
      if (_localeInitialized) {
        final dateFormat = DateFormat('d MMMM, EEEE', 'ru');
        formattedDate = dateFormat.format(now);
      } else {
        formattedDate = DateFormat('dd.MM.yyyy').format(now);
      }
    } catch (e) {
      formattedDate = '${now.day}.${now.month}.${now.year}';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добро пожаловать! 👋',
              style: AppTextStyles.h1.copyWith(fontSize: 28),
            ),
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
                  formattedDate,
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
            _buildHeaderButton(
              Icons.notifications_outlined,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Уведомления - в разработке')),
                );
              },
              badge: _newRequests.length + _unreadMessages.length,
            ),
            const SizedBox(width: 12),
            _buildHeaderButton(
              Icons.settings_outlined,
              () => Navigator.pushNamed(context, AppRouter.profile),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton(
    IconData icon,
    VoidCallback onPressed, {
    int? badge,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(icon, color: AppColors.textPrimary),
            onPressed: onPressed,
          ),
          if (badge != null && badge > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  badge > 9 ? '9+' : badge.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewRequestsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warning.withOpacity(0.1),
            AppColors.warning.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active,
                  color: AppColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Новые заявки',
                      style: AppTextStyles.h2.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'У вас ${_newRequests.length} ${_getRequestsText(_newRequests.length)}',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.psychoSchedule);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Посмотреть'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...(_newRequests
              .take(3)
              .map((request) => _buildRequestCard(request))),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['clientName'] ?? 'Клиент',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(
                    request['appointmentDate'],
                    request['appointmentTime'],
                  ),
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _handleRejectRequest(request['id']),
                icon: const Icon(Icons.close, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _handleConfirmRequest(request['id']),
                icon: const Icon(Icons.check, color: AppColors.success),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.success.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
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
              Text('Предстоящие сессии', style: AppTextStyles.h2),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.psychoSchedule),
                child: Text(
                  'Все',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_upcomingSessions.isEmpty)
            _buildEmptyState(
              'Нет запланированных сессий',
              Icons.event_available,
            )
          else
            ...(_upcomingSessions
                .take(3)
                .map((session) => _buildSessionCard(session))),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.person, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['clientName'] ?? 'Клиент',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDateTime(
                        session['appointmentDate'],
                        session['appointmentTime'],
                      ),
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _handleStartSession(session['id']),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Начать',
              style: AppTextStyles.button.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    final stats = _statistics ?? {};
    final sessionStats = stats['sessionStats'] ?? {};
    final clientStats = stats['clientStats'] ?? {};
    final ratingStats = stats['ratingStats'] ?? {};

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            sessionStats['totalCompletedSessions']?.toString() ?? '0',
            'Сессий проведено',
            Icons.event_available,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            clientStats['activeClients']?.toString() ?? '0',
            'Активных клиентов',
            Icons.people,
            Colors.green,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            ratingStats['averageRating']?.toStringAsFixed(1) ?? '0.0',
            'Рейтинг',
            Icons.star,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: color,
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

  Widget _buildUnreadMessagesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
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
              Text('Новые сообщения', style: AppTextStyles.h2),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.psychoMessages),
                child: Text(
                  'Все',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...(_unreadMessages
              .take(3)
              .map((message) => _buildMessageCard(message))),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouter.psychoMessages);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['senderName'] ?? 'Клиент',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message['lastMessage'] ?? 'Новое сообщение',
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Быстрые действия', style: AppTextStyles.h2),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Просмотреть расписание',
                  Icons.calendar_month,
                  AppColors.primary,
                  () => Navigator.pushNamed(context, AppRouter.psychoSchedule),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  'Мои отчеты',
                  Icons.assessment,
                  Colors.purple,
                  () => Navigator.pushNamed(context, AppRouter.psychoReports),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 64, color: AppColors.textTertiary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? date, String? time) {
    if (date == null || time == null) return 'Не указано';
    try {
      final dateTime = DateTime.parse('$date $time');
      if (_localeInitialized) {
        final format = DateFormat('d MMM, HH:mm', 'ru');
        return format.format(dateTime);
      } else {
        return '${dateTime.day}.${dateTime.month}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return '$date, $time';
    }
  }

  String _getRequestsText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'новая заявка';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'новые заявки';
    } else {
      return 'новых заявок';
    }
  }

  Future<void> _handleConfirmRequest(int requestId) async {
    try {
      final confirmed = await _apiService.confirmAppointment(requestId);
      if (confirmed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись подтверждена'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleRejectRequest(int requestId) async {
    try {
      final rejected = await _apiService.rejectAppointment(requestId, null);
      if (rejected && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись отклонена'),
            backgroundColor: AppColors.error,
          ),
        );
        _loadDashboardData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleStartSession(int sessionId) async {
    try {
      final started = await _apiService.startSession(sessionId);
      if (started && mounted) {
        Navigator.pushNamed(context, AppRouter.psychoMessages);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
