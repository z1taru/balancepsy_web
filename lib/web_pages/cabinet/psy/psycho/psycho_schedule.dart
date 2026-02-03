// lib/web_pages/cabinet/psy/psycho/psycho_schedule.dart
//
// Страница расписания психолога.
//   ├─ Недельное расписание слотов  (добавить / удалить)
//   ├─ Ближайшие записи (upcoming)  — PENDING, CONFIRMED, IN_PROGRESS
//   └─ Прошедшие записи  (past)     — COMPLETED, NO_SHOW, CANCELLED
//        └─ кнопка «Написать отчёт» для COMPLETED (TODO: навигация)
//
// Ручное создание записи:
//   Психолог может добавить запись вручную — поиск клиента по имени,
//   выбор даты / времени / формата, тема.

import 'package:flutter/material.dart';
import '../../../../widgets/unified_sidebar.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../../core/services/appointment_api_service.dart';
import '../../../../models/schedule_slot.dart';

class PsychoSchedulePage extends StatefulWidget {
  const PsychoSchedulePage({super.key});

  @override
  State<PsychoSchedulePage> createState() => _PsychoSchedulePageState();
}

class _PsychoSchedulePageState extends State<PsychoSchedulePage> {
  final ScheduleService _scheduleService = ScheduleService();
  final AppointmentApiService _appointmentService = AppointmentApiService();

  List<ScheduleSlot> _scheduleSlots = [];
  List<Map<String, dynamic>> _upcoming =
      []; // PENDING | CONFIRMED | IN_PROGRESS
  List<Map<String, dynamic>> _past =
      []; // COMPLETED | NO_SHOW | CANCELLED  или  дата < сегодня
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ── загрузка ──────────────────────────────
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final slots = await _scheduleService.getMySchedule();
      final allAppointments = await _appointmentService
          .getPsychologistAppointments();

      _splitAppointments(allAppointments);

      setState(() {
        _scheduleSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ psycho_schedule loadData: $e');
      setState(() => _isLoading = false);
    }
  }

  // ── разделение записей на upcoming / past ──
  void _splitAppointments(List<Map<String, dynamic>> all) {
    final now = DateTime.now();
    _upcoming = [];
    _past = [];

    for (final apt in all) {
      final status = (apt['status'] as String).toUpperCase();

      // Терминальные статусы — всегда в past
      if (status == 'COMPLETED' ||
          status == 'NO_SHOW' ||
          status == 'CANCELLED') {
        _past.add(apt);
        continue;
      }

      // Для остальных (PENDING, CONFIRMED, IN_PROGRESS) смотрим дату
      final aptDate = _parseDate(apt['appointmentDate']);
      if (aptDate != null &&
          aptDate.isBefore(DateTime(now.year, now.month, now.day))) {
        _past.add(apt); // дата уже прошла
      } else {
        _upcoming.add(apt);
      }
    }

    // Сортировка: upcoming по возрастанию даты, past по убыванию
    _upcoming.sort(_compareDates(ascending: true));
    _past.sort(_compareDates(ascending: false));
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }

  Comparator<Map<String, dynamic>> _compareDates({required bool ascending}) {
    return (a, b) {
      final da = _parseDate(a['appointmentDate']);
      final db = _parseDate(b['appointmentDate']);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return ascending ? da.compareTo(db) : db.compareTo(da);
    };
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          const UnifiedSidebar(currentRoute: '/psycho/schedule'),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildScheduleSection(),
                        const SizedBox(height: 24),
                        _buildUpcomingSection(),
                        const SizedBox(height: 24),
                        _buildPastSection(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── заголовок ─────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Расписание приёмов',
              style: AppTextStyles.h1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Управляйте доступным временем и записями',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Кнопка добавить слот
            ElevatedButton.icon(
              onPressed: _showAddSlotDialog,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Слот'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Кнопка ручная запись
            ElevatedButton.icon(
              onPressed: _showManualAppointmentDialog,
              icon: const Icon(Icons.person_add, size: 20),
              label: const Text('Записать клиента'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── недельное расписание слотов ───────────
  Widget _buildScheduleSection() {
    if (_scheduleSlots.isEmpty) {
      return _buildEmptyCard(
        icon: Icons.calendar_month,
        title: 'Расписание не настроено',
        subtitle: 'Добавьте слоты для записи клиентов',
      );
    }

    final grouped = <int, List<ScheduleSlot>>{};
    for (final slot in _scheduleSlots) {
      grouped.putIfAbsent(slot.dayOfWeek, () => []).add(slot);
    }

    return _buildCard(
      title: 'Недельное расписание',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grouped.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildDaySlots(entry.key, entry.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDaySlots(int dayOfWeek, List<ScheduleSlot> slots) {
    const days = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          days[dayOfWeek - 1],
          style: AppTextStyles.h3.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map(_buildSlotChip).toList(),
        ),
      ],
    );
  }

  Widget _buildSlotChip(ScheduleSlot slot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            '${slot.startTime} – ${slot.endTime}',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteSlot(slot.id),
            child: const Icon(Icons.close, size: 15, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  // ── upcoming ──────────────────────────────
  Widget _buildUpcomingSection() {
    return _buildCard(
      title: 'Ближайшие записи',
      badge: _upcoming.length.toString(),
      child: _upcoming.isEmpty
          ? _buildInlineEmpty('Нет предстоящих записей')
          : Column(
              children: _upcoming
                  .map(
                    (apt) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildAppointmentCard(apt, isPast: false),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // ── past ──────────────────────────────────
  Widget _buildPastSection() {
    return _buildCard(
      title: 'Прошедшие записи',
      badge: _past.length.toString(),
      child: _past.isEmpty
          ? _buildInlineEmpty('Прошедших записей нет')
          : Column(
              children: _past
                  .map(
                    (apt) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildAppointmentCard(apt, isPast: true),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // ── карточка одной записи ─────────────────
  Widget _buildAppointmentCard(
    Map<String, dynamic> apt, {
    required bool isPast,
  }) {
    final status = (apt['status'] as String).toUpperCase();
    final clientName = apt['clientName'] ?? 'Клиент';
    final date = apt['appointmentDate']?.toString() ?? '';
    final start = apt['startTime']?.toString() ?? '';
    final end = apt['endTime']?.toString() ?? '';
    final format = apt['format']?.toString() ?? '';
    final id = apt['id'] as int;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor(status).withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // аватар
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$date  •  $start – $end  •  $format',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // статус-бейдж
          _buildStatusBadge(status),
          const SizedBox(width: 10),
          // меню действий
          _buildActionsMenu(id, status, isPast),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _statusColor(status);
    final label = _statusLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.body3.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── меню действий ─────────────────────────
  Widget _buildActionsMenu(int id, String status, bool isPast) {
    final items = <PopupMenuEntry<String>>[];

    switch (status) {
      case 'PENDING':
        items.add(
          PopupMenuItem(value: 'confirm', child: const Text('Подтвердить')),
        );
        items.add(
          PopupMenuItem(value: 'reject', child: const Text('Отклонить')),
        );
        items.add(
          PopupMenuItem(value: 'cancel', child: const Text('Отменить')),
        );
        break;
      case 'CONFIRMED':
        items.add(
          PopupMenuItem(value: 'start', child: const Text('Начать сессию')),
        );
        items.add(
          PopupMenuItem(value: 'noshow', child: const Text('Не явился')),
        );
        items.add(
          PopupMenuItem(value: 'cancel', child: const Text('Отменить')),
        );
        break;
      case 'IN_PROGRESS':
        items.add(
          PopupMenuItem(
            value: 'complete',
            child: const Text('Завершить сессию'),
          ),
        );
        items.add(
          PopupMenuItem(value: 'noshow', child: const Text('Не явился')),
        );
        break;
      case 'COMPLETED':
        items.add(
          PopupMenuItem(value: 'report', child: const Text('Написать отчёт')),
        );
        break;
      default:
        // CANCELLED, NO_SHOW — действий нет
        break;
    }

    if (items.isEmpty) return const SizedBox(width: 32);

    return PopupMenuButton<String>(
      iconColor: AppColors.textSecondary,
      iconSize: 20,
      itemBuilder: (_) => items,
      onSelected: (action) => _handleAction(id, action),
    );
  }

  Future<void> _handleAction(int id, String action) async {
    try {
      switch (action) {
        case 'confirm':
          await _appointmentService.confirmAppointment(id);
          _showSnack('Запись подтверждена');
          break;
        case 'reject':
          await _appointmentService.rejectAppointment(id);
          _showSnack('Запись отклонена');
          break;
        case 'start':
          await _appointmentService.startAppointment(id);
          _showSnack('Сессия начата');
          break;
        case 'complete':
          await _appointmentService.completeAppointment(id);
          _showSnack('Сессия завершена');
          break;
        case 'noshow':
          await _appointmentService.markNoShow(id);
          _showSnack('Отмечено: клиент не явился');
          break;
        case 'cancel':
          await _appointmentService.cancelAppointment(id);
          _showSnack('Запись отменена');
          break;
        case 'report':
          // TODO: навигация на страницу написания отчёта
          _showSnack('Написание отчётов — в разработке');
          return; // без перезагрузки
      }
      await _loadData(); // перезагрузка после успешного действия
    } catch (e) {
      _showSnack('Ошибка: $e', isError: true);
    }
  }

  // ── диалог добавления слота ───────────────
  Future<void> _showAddSlotDialog() async {
    int? selectedDay;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Добавить слот', style: AppTextStyles.h3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'День недели',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectedDay,
                items: List.generate(7, (i) {
                  const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                  return DropdownMenuItem(value: i + 1, child: Text(days[i]));
                }),
                onChanged: (v) => setDialogState(() => selectedDay = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null)
                          setDialogState(() => startTime = picked);
                      },
                      child: Text(
                        startTime != null ? _formatTime(startTime!) : 'Начало',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null)
                          setDialogState(() => endTime = picked);
                      },
                      child: Text(
                        endTime != null ? _formatTime(endTime!) : 'Конец',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDay == null || startTime == null || endTime == null)
                  return;
                try {
                  await _scheduleService.createScheduleSlot(
                    dayOfWeek: selectedDay!,
                    startTime: _formatTime(startTime!),
                    endTime: _formatTime(endTime!),
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                  await _loadData();
                  _showSnack('Слот создан');
                } catch (e) {
                  _showSnack('Ошибка: $e', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Добавить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── удалить слот ──────────────────────────
  Future<void> _deleteSlot(int slotId) async {
    try {
      await _scheduleService.deleteScheduleSlot(slotId);
      await _loadData();
      _showSnack('Слот удалён');
    } catch (e) {
      _showSnack('Ошибка: $e', isError: true);
    }
  }

  // ── диалог ручной записи ──────────────────
  Future<void> _showManualAppointmentDialog() async {
    final TextEditingController searchCtrl = TextEditingController();
    final TextEditingController issueCtrl = TextEditingController();

    int? selectedClientId;
    String? selectedClientName;
    DateTime? selectedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String selectedFormat = 'VIDEO';

    List<Map<String, dynamic>> searchResults = [];

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          // debounce-поиск при изменении текста
          searchCtrl.addListener(() async {
            final q = searchCtrl.text.trim();
            if (q.length >= 2) {
              try {
                final results = await _appointmentService.searchClients(q);
                if (ctx.mounted) setDialogState(() => searchResults = results);
              } catch (_) {}
            } else {
              if (ctx.mounted) setDialogState(() => searchResults = []);
            }
          });

          return AlertDialog(
            title: Text('Записать клиента вручную', style: AppTextStyles.h3),
            content: SizedBox(
              width: 480,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── поиск клиента ──
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        labelText: 'Имя клиента',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (searchResults.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.inputBorder.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (_, i) {
                            final c = searchResults[i];
                            final cName =
                                c['fullName'] ?? c['name'] ?? 'Без имени';
                            final cId = c['userId'] ?? c['id'];
                            return ListTile(
                              title: Text(cName),
                              subtitle: Text(c['email'] ?? ''),
                              onTap: () => setDialogState(() {
                                selectedClientId = cId as int?;
                                selectedClientName = cName;
                                searchCtrl.text = cName;
                                searchResults = [];
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                    if (selectedClientName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Выбран: $selectedClientName',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),

                    const SizedBox(height: 18),
                    // ── дата ──
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        selectedDate != null
                            ? _formatDateTime(selectedDate!)
                            : 'Выбрать дату',
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 60),
                          ),
                          initialDate: selectedDate ?? DateTime.now(),
                        );
                        if (picked != null)
                          setDialogState(() => selectedDate = picked);
                      },
                    ),

                    const SizedBox(height: 12),
                    // ── время ──
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    startTime ??
                                    const TimeOfDay(hour: 9, minute: 0),
                              );
                              if (picked != null)
                                setDialogState(() => startTime = picked);
                            },
                            child: Text(
                              startTime != null
                                  ? _formatTime(startTime!)
                                  : 'Начало',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('–'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    endTime ??
                                    const TimeOfDay(hour: 10, minute: 0),
                              );
                              if (picked != null)
                                setDialogState(() => endTime = picked);
                            },
                            child: Text(
                              endTime != null ? _formatTime(endTime!) : 'Конец',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    // ── формат ──
                    Text(
                      'Формат',
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: ['VIDEO', 'CHAT', 'AUDIO'].map((f) {
                        final sel = selectedFormat == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f),
                            selected: sel,
                            onSelected: (_) =>
                                setDialogState(() => selectedFormat = f),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: sel ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 14),
                    // ── тема ──
                    TextField(
                      controller: issueCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Тема обращения (необязательно)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedClientId == null ||
                      selectedDate == null ||
                      startTime == null ||
                      endTime == null) {
                    _showSnack(
                      'Заполните поля: клиент, дата, время',
                      isError: true,
                    );
                    return;
                  }
                  try {
                    // TODO: передать psychologistId из UserProvider
                    // Пока берём из профиля — нужно добавить в UserProvider
                    await _appointmentService.createAppointmentManual(
                      psychologistId:
                          0, // TODO заменить на реальный id из UserProvider
                      clientId: selectedClientId,
                      appointmentDate: _toIsoDate(selectedDate!),
                      startTime: _formatTime(startTime!),
                      endTime: _formatTime(endTime!),
                      format: selectedFormat,
                      issueDescription: issueCtrl.text.trim().isEmpty
                          ? null
                          : issueCtrl.text.trim(),
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                    await _loadData();
                    _showSnack('Запись создана');
                  } catch (e) {
                    _showSnack('Ошибка: $e', isError: true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                ),
                child: const Text(
                  'Создать запись',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
    searchCtrl.dispose();
    issueCtrl.dispose();
  }

  // ── helpers ───────────────────────────────
  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning;
      case 'CONFIRMED':
        return AppColors.primary;
      case 'IN_PROGRESS':
        return const Color(0xFF8B5CF6); // фиолетовый
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.textTertiary;
      case 'NO_SHOW':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Ожидается';
      case 'CONFIRMED':
        return 'Подтверждена';
      case 'IN_PROGRESS':
        return 'Идёт сессия';
      case 'COMPLETED':
        return 'Завершена';
      case 'CANCELLED':
        return 'Отменена';
      case 'NO_SHOW':
        return 'Не явился';
      default:
        return status;
    }
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  String _formatDateTime(DateTime d) =>
      '${d.day}.${(d.month).toString().padLeft(2, '0')}.${d.year}';
  String _toIsoDate(DateTime d) =>
      '${d.year}-${(d.month).toString().padLeft(2, '0')}-${(d.day).toString().padLeft(2, '0')}';

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  // ── reusable card shell ───────────────────
  Widget _buildCard({
    required String title,
    required Widget child,
    String? badge,
  }) {
    return Container(
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: AppTextStyles.h2),
              if (badge != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 14),
            Text(title, style: AppTextStyles.h3),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineEmpty(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Center(
      child: Text(
        text,
        style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
      ),
    ),
  );
}
