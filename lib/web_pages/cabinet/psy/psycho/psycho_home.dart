// lib/web_pages/cabinet/psy/psycho/psycho_dashboard_improved.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/unified_sidebar.dart';
import '../../../../сore/services/psychologist_api_service.dart';
import '../../../../сore/router/app_router.dart';

class PsyHome extends StatefulWidget {
  const PsyHome({super.key});

  @override
  State<PsyHome> createState() =>
      _PsyHomeState();
}

class _PsyHomeState
    extends State<PsyHome> {
  final PsychologistApiService _apiService = PsychologistApiService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _upcomingSessions = [];
  List<Map<String, dynamic>> _newRequests = [];
  List<Map<String, dynamic>> _unreadMessages = [];
  Map<String, dynamic>? _statistics;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _apiService.getUpcomingSessions(),
        _apiService.getNewRequests(),
        _apiService.getUnreadMessages(),
        _apiService.getStatistics(),
      ]);

      setState(() {
        _upcomingSessions = results[0] as List<Map<String, dynamic>>;
        _newRequests = results[1] as List<Map<String, dynamic>>;
        _unreadMessages = results[2] as List<Map<String, dynamic>>;
        _statistics = results[3] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading dashboard: $e');
      setState(() => _isLoading = false);
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
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final dateFormat = DateFormat('d MMMM, EEEE', 'ru');

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
                  dateFormat.format(now),
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
                // TODO: Открыть уведомления
              },
              badge: _newRequests.length + _unreadMessages.length,
            ),
            const SizedBox(width: 12),
            _buildHeaderButton(Icons.settings_outlined, () {
              Navigator.pushNamed(context, AppRouter.psychoProfile);
            }),
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
                  // TODO: Перейти к заявкам
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
            backgroundImage: request['clientAvatar'] != null
                ? NetworkImage(request['clientAvatar'])
                : null,
            child: request['clientAvatar'] == null
                ? const Icon(Icons.person, size: 28)
                : null,
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
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.psychoSchedule);
                },
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
            ...(_upcomingSessions.map((session) => _buildSessionCard(session))),
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
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: session['clientAvatar'] != null
                    ? NetworkImage(session['clientAvatar'])
                    : null,
                child: session['clientAvatar'] == null
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
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
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.psychoMessages);
                },
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
          // TODO: Открыть чат
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: message['senderAvatar'] != null
                        ? NetworkImage(message['senderAvatar'])
                        : null,
                    child: message['senderAvatar'] == null
                        ? const Icon(Icons.person, size: 28)
                        : null,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        message['unreadCount']?.toString() ?? '1',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
                      message['lastMessage'] ?? '',
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
      final format = DateFormat('d MMM, HH:mm', 'ru');
      return format.format(dateTime);
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
    final confirmed = await _apiService.confirmAppointment(requestId);
    if (confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Запись подтверждена'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadDashboardData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось подтвердить запись'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleRejectRequest(int requestId) async {
    final rejected = await _apiService.rejectAppointment(requestId, null);
    if (rejected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Запись отклонена'),
          backgroundColor: AppColors.error,
        ),
      );
      _loadDashboardData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось отклонить запись'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleStartSession(int sessionId) async {
    final started = await _apiService.startSession(sessionId);
    if (started) {
      // TODO: Открыть чат сессии
      Navigator.pushNamed(context, AppRouter.psychoMessages);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось начать сессию'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
