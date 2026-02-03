// lib/web_pages/main/psychologists/psychologist_detail.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/user_provider.dart';
import '../../../../core/services/psychologist_service.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../../models/schedule_slot.dart';

class PsychologistDetail extends StatefulWidget {
  final String id;
  const PsychologistDetail({super.key, required this.id});

  @override
  State<PsychologistDetail> createState() => _PsychologistDetailState();
}

class _PsychologistDetailState extends State<PsychologistDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PsychologistService _psychologistService = PsychologistService();
  final ScheduleService _scheduleService = ScheduleService();

  Map<String, dynamic>? _psychologist;
  List<ScheduleSlot> _scheduleSlots = [];
  bool _isLoading = true;
  String? _error;

  // ── ближайший доступный слот (для краткой info на странице) ──
  String? get _nearestSlotLabel {
    if (_scheduleSlots.isEmpty) return null;
    final now = DateTime.now();
    // Ищем ближайший слот в будущем
    for (var i = 0; i < 28; i++) {
      final date = now.add(Duration(days: i));
      for (final slot in _scheduleSlots) {
        if (date.weekday == slot.dayOfWeek) {
          // Если сегодня — пропускаем прошедшие время
          if (i == 0) {
            final parts = slot.startTime.split(':');
            final slotHour = int.parse(parts[0]);
            if (slotHour <= now.hour) continue;
          }
          final months = ['янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
          return '${date.day} ${months[date.month - 1]}, ${slot.startTime}';
        }
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── загрузка психолога + его расписания параллельно ────────────
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final psychologistId = int.tryParse(widget.id);
      if (psychologistId == null) {
        throw Exception('Неверный ID психолога');
      }

      // Параллельная загрузка — не ждём друг друга
      final results = await Future.wait([
        _psychologistService.getPsychologistById(psychologistId),
        _scheduleService.getPsychologistSchedule(psychologistId),
      ]);

      setState(() {
        _psychologist = results[0] as Map<String, dynamic>;
        _scheduleSlots = results[1] as List<ScheduleSlot>;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading psychologist detail: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ─── навигация в booking ────────────────────────────────────────
  void _handleBooking() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!userProvider.isAuthenticated) {
      _showLoginDialog();
      return;
    }

    if (userProvider.userRole == 'PSYCHOLOGIST') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Психологи не могут записываться на консультации'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final psychologistId = int.tryParse(widget.id) ?? 0;

    // Сериализуем слоты в простые maps для передачи через arguments
    final serializedSlots = _scheduleSlots.map((s) => {
      'id': s.id,
      'dayOfWeek': s.dayOfWeek,
      'startTime': s.startTime,
      'endTime': s.endTime,
    }).toList();

    Navigator.pushNamed(
      context,
      '/booking/$psychologistId',
      arguments: {
        'name': _psychologist?['fullName'] ?? 'Психолог',
        'slots': serializedSlots, // передаём уже загруженные слоты
      },
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.lock_outline, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text('Требуется авторизация', style: AppTextStyles.h3.copyWith(fontSize: 22))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Для записи на консультацию необходимо войти в аккаунт или создать новый.',
              style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Это займет всего минуту!', style: AppTextStyles.body2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, AppRouter.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Войти', style: AppTextStyles.button),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, AppRouter.register);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Регистрация', style: AppTextStyles.body1.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _psychologist == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Ошибка загрузки', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(_error ?? 'Психолог не найден', style: AppTextStyles.body1),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text('Назад', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      );
    }

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
            _buildAvailabilityBanner(isMobile),   // ← NEW: краткая info о доступности
            _buildTabs(isMobile, isTablet),
            _buildTabContent(isMobile, isTablet),
            _buildBookingSection(isMobile, isTablet),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeader(bool isMobile, bool isTablet) {
    final avatarUrl = _psychologist?['avatarUrl'];
    final fullName = _psychologist?['fullName'] ?? 'Психолог';
    final specialization = _psychologist?['specialization'] ?? '';

    return Container(
      height: isMobile ? 320 : 450,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primaryDark.withOpacity(0.9)],
        ),
      ),
      child: Stack(
        children: [
          if (avatarUrl != null && avatarUrl.isNotEmpty)
            Positioned.fill(
              child: Opacity(opacity: 0.2, child: Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox())),
            ),
          Positioned(
            top: 40,
            left: isMobile ? 20 : 80,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isMobile ? 100 : 120,
                  height: isMobile ? 100 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: ClipOval(
                    child: avatarUrl != null && avatarUrl.isNotEmpty
                        ? Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatarPlaceholder())
                        : _buildAvatarPlaceholder(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(fullName, style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 32 : 48, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text(specialization, style: AppTextStyles.body1.copyWith(fontSize: isMobile ? 18 : 24, color: Colors.white), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.white,
      child: Center(child: Icon(Icons.person, size: 60, color: AppColors.primary.withOpacity(0.5))),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MAIN INFO (рейтинг, опыт, сессии, статус)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMainInfo(bool isMobile, bool isTablet) {
    final bio = _psychologist?['bio'] ?? 'Нет описания';
    final rating = (_psychologist?['rating'] ?? 0.0).toDouble();
    final reviewsCount = _psychologist?['reviewsCount'] ?? 0;
    final experienceYears = _psychologist?['experienceYears'] ?? 0;
    final totalSessions = _psychologist?['totalSessions'] ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : (isTablet ? 40 : 80), vertical: 40),
      child: Column(
        children: [
          Text(bio, style: AppTextStyles.body1.copyWith(fontSize: isMobile ? 16 : 18, color: AppColors.textSecondary, height: 1.6), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          Wrap(
            spacing: isMobile ? 16 : 32,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildInfoCard(Icons.star_rounded, rating.toStringAsFixed(1), '$reviewsCount отзывов', isMobile),
              _buildInfoCard(Icons.work_history_rounded, '$experienceYears лет', 'Опыт работы', isMobile),
              _buildInfoCard(Icons.people_rounded, '$totalSessions', 'Сессий проведено', isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label, bool isMobile, {Color? color}) {
    return Container(
      width: isMobile ? 140 : 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.shadow.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color ?? AppColors.primary),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3.copyWith(fontSize: 24, color: color ?? AppColors.primary), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // AVAILABILITY BANNER — краткая info о доступных слотах
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAvailabilityBanner(bool isMobile) {
    final hasSlots = _scheduleSlots.isNotEmpty;
    final nearestLabel = _nearestSlotLabel;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: hasSlots ? AppColors.success.withOpacity(0.07) : AppColors.error.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasSlots ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: hasSlots ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasSlots ? Icons.calendar_today_rounded : Icons.calendar_today,
              color: hasSlots ? AppColors.success : AppColors.error,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSlots ? 'Есть доступные слоты' : 'Пока нет доступных слотов',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasSlots ? AppColors.success : AppColors.error,
                  ),
                ),
                if (nearestLabel != null)
                  Text(
                    'Ближайший: $nearestLabel',
                    style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TABS
  // ═══════════════════════════════════════════════════════════════
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
        tabs: const [Tab(text: 'О специалисте'), Tab(text: 'Образование'), Tab(text: 'Отзывы')],
      ),
    );
  }

  Widget _buildTabContent(bool isMobile, bool isTablet) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : (isTablet ? 40 : 80), vertical: 40),
      child: SizedBox(
        height: 600,
        child: TabBarView(
          controller: _tabController,
          children: [_buildAboutTab(isMobile), _buildEducationTab(isMobile), _buildReviewsTab()],
        ),
      ),
    );
  }

  // ── О специалисте ──
  Widget _buildAboutTab(bool isMobile) {
    final approaches = _psychologist?['approaches'] as List<dynamic>? ?? [];
    final workFormat = _psychologist?['workFormat'] ?? 'Онлайн консультации';

    return ListView(
      children: [
        _buildSectionTitle('Подход в работе'),
        const SizedBox(height: 16),
        if (approaches.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: approaches.map((approach) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
              child: Text(approach.toString(), style: AppTextStyles.body2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        const SizedBox(height: 32),
        _buildSectionTitle('Формат работы'),
        const SizedBox(height: 16),
        Text(workFormat, style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary, height: 1.6, fontSize: isMobile ? 16 : 18)),
      ],
    );
  }

  // ── Образование ──
  Widget _buildEducationTab(bool isMobile) {
    final education = _psychologist?['education'] ?? 'Информация отсутствует';
    final certificates = _psychologist?['certificates'] as List<dynamic>? ?? [];

    return ListView(
      children: [
        _buildSectionTitle('Образование'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(child: Text(education, style: AppTextStyles.body1.copyWith(fontSize: isMobile ? 16 : 18, height: 1.5))),
            ],
          ),
        ),
        if (certificates.isNotEmpty) ...[
          const SizedBox(height: 32),
          _buildSectionTitle('Сертификаты'),
          const SizedBox(height: 16),
          ...certificates.map((cert) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
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
                  Expanded(child: Text(cert.toString(), style: AppTextStyles.body1.copyWith(fontSize: isMobile ? 16 : 18))),
                ],
              ),
            ),
          )),
        ],
      ],
    );
  }

  // ── Отзывы ──
  Widget _buildReviewsTab() {
    final rating = (_psychologist?['rating'] ?? 0.0).toDouble();
    final reviewsCount = _psychologist?['reviewsCount'] ?? 0;

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              Text(rating.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: 48, color: AppColors.primary)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => Icon(
                  i < rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.warning, size: 28,
                )),
              ),
              const SizedBox(height: 12),
              Text('$reviewsCount отзывов', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary, fontSize: 16)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Center(child: Text('Отзывы появятся после первых консультаций', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary))),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.h3.copyWith(fontSize: 24, fontWeight: FontWeight.bold));
  }

  // ═══════════════════════════════════════════════════════════════
  // BOOKING CTA — кнопка записи + цена
  // ═══════════════════════════════════════════════════════════════
  Widget _buildBookingSection(bool isMobile, bool isTablet) {
    final hourlyRate = (_psychologist?['hourlyRate'] ?? 0).toInt();
    final hasSlots = _scheduleSlots.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : (isTablet ? 40 : 80), vertical: isMobile ? 60 : 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary.withOpacity(0.05), AppColors.primaryLight.withOpacity(0.1)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Готовы начать путь к балансу?',
            style: AppTextStyles.h2.copyWith(fontSize: isMobile ? 28 : 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Запишитесь на первую консультацию и сделайте шаг к лучшей версии себя.',
            style: AppTextStyles.body1.copyWith(fontSize: isMobile ? 16 : 18, color: AppColors.textSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (hourlyRate > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('от $hourlyRate ₸', style: AppTextStyles.h3.copyWith(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.bold)),
                Text(' / час', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: isMobile ? double.infinity : 320,
            height: 56,
            child: ElevatedButton(
              // Кнопка активна всегда; если слотов нет — BookingPage покажет соответствующий UI
              onPressed: _handleBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(hasSlots ? Icons.calendar_month : Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    hasSlots ? 'Записаться на консультацию' : 'Проверить доступность',
                    style: AppTextStyles.body1.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}