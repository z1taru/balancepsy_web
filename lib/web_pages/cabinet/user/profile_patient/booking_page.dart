// lib/web_pages/cabinet/user/profile_patient/booking_page.dart
//
// Чистая форма записи.
// Данные (слоты) приходят через route-arguments из PsychologistDetail.
// Этот экран НЕ делает fetch слотов сам.

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../models/session_format.dart';
import '../../../../core/services/appointment_api_service.dart';

class BookingPage extends StatefulWidget {
  final int psychologistId;
  final String psychologistName;

  /// Список слотов, полученных из arguments.
  /// Каждый элемент — Map с ключами: dayOfWeek, startTime, endTime.
  final List<Map<String, dynamic>> scheduleSlots;

  const BookingPage({
    super.key,
    required this.psychologistId,
    required this.psychologistName,
    required this.scheduleSlots,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final AppointmentApiService _appointmentService = AppointmentApiService();
  final TextEditingController _issueController = TextEditingController();

  // ── пошаговый state ──
  int _currentStep = 0;
  SessionFormat? _selectedFormat;
  DateTime? _selectedDate;
  Map<String, dynamic>?
  _selectedSlot; // выбранный слот {startTime, endTime, ...}
  bool _isSubmitting = false;

  // ── вычисленные из слотов ──
  /// Список уникальных дат, на которых есть хотя бы один слот (следующие 28 дней)
  late final List<DateTime> _availableDates;

  /// Слоты, сгруппированные по дате-ключу «yyyy-M-d»
  late final Map<String, List<Map<String, dynamic>>> _slotsByDate;

  @override
  void initState() {
    super.initState();
    _computeSlots();
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  // ─── Генерация доступных дат из шаблона расписания ──────────────
  // scheduleSlots содержит *шаблон* недели (dayOfWeek + startTime + endTime).
  // Раскрываем его на 28 дней вперёд — аналогично тому, как это было в старом
  // _generateAvailableSlots, но без зависимости от ScheduleService.
  void _computeSlots() {
    final now = DateTime.now();
    final byDate = <String, List<Map<String, dynamic>>>{};

    for (var i = 0; i < 28; i++) {
      final date = now.add(Duration(days: i));

      for (final slot in widget.scheduleSlots) {
        final dayOfWeek = slot['dayOfWeek'] as int;
        if (date.weekday != dayOfWeek) continue;

        // Пропускаем уже прошедшие слоты сегодня
        if (i == 0) {
          final parts = (slot['startTime'] as String).split(':');
          if (int.parse(parts[0]) <= now.hour) continue;
        }

        final key = '${date.year}-${date.month}-${date.day}';
        byDate.putIfAbsent(key, () => []).add({
          ...slot,
          '_date': date, // сохраняем объект DateTime для удобства
        });
      }
    }

    _slotsByDate = byDate;
    _availableDates = byDate.keys.map((key) {
      final p = key.split('-');
      return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    }).toList()..sort();
  }

  // ─── слоты для текущей выбранной даты ───────────────────────────
  List<Map<String, dynamic>> get _slotsForSelectedDate {
    if (_selectedDate == null) return [];
    final key =
        '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
    return _slotsByDate[key] ?? [];
  }

  // ─── валидация текущего шага ────────────────────────────────────
  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedFormat != null;
      case 1:
        return _selectedDate != null;
      case 2:
        return _selectedSlot != null;
      case 3:
        return true; // тема необязательна
      default:
        return false;
    }
  }

  // ─── отправка ───────────────────────────────────────────────────
  Future<void> _submitBooking() async {
    if (_selectedFormat == null ||
        _selectedDate == null ||
        _selectedSlot == null)
      return;

    setState(() => _isSubmitting = true);

    try {
      final dateStr =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

      await _appointmentService.createAppointment(
        psychologistId: widget.psychologistId,
        appointmentDate: dateStr,
        startTime: _selectedSlot!['startTime'] as String,
        endTime: _selectedSlot!['endTime'] as String,
        format: _selectedFormat!.name,
        issueDescription: _issueController.text.trim().isEmpty
            ? null
            : _issueController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись создана! Психолог скоро подтвердит.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Запись к ${widget.psychologistName}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _availableDates.isEmpty
          ? _buildEmptyState() // нет слотов вообще
          : _buildStepper(),
    );
  }

  // ─── пустой state — нет слотов ──────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 80, color: AppColors.textTertiary),
          const SizedBox(height: 24),
          Text(
            'Пока нет доступных слотов',
            style: AppTextStyles.h3.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 12),
          Text(
            'У ${widget.psychologistName} сейчас нет свободных окон.\nПроверьте позже или выберите другого специалиста.',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Назад', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  // ─── main stepper ───────────────────────────────────────────────
  Widget _buildStepper() {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: () {
        if (!_canProceed) return;

        if (_currentStep < 3) {
          setState(() {
            _currentStep++;
            // при смене даты сбрасываем выбранный слот
            if (_currentStep == 2) _selectedSlot = null;
          });
        } else {
          _submitBooking();
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) setState(() => _currentStep--);
      },
      controlsBuilder: (context, details) {
        final isLastStep = _currentStep == 3;
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _isSubmitting ? null : details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isLastStep ? 'Записаться' : 'Далее',
                        style: AppTextStyles.button,
                      ),
              ),
              const SizedBox(width: 12),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text('Назад', style: AppTextStyles.body1),
                ),
            ],
          ),
        );
      },
      steps: [
        Step(
          title: const Text('Формат консультации'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          content: _buildFormatStep(),
        ),
        Step(
          title: const Text('Выбор даты'),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          content: _buildDateStep(),
        ),
        Step(
          title: const Text('Выбор времени'),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          content: _buildTimeStep(),
        ),
        Step(
          title: const Text('Тема обращения'),
          isActive: _currentStep >= 3,
          state: StepState.indexed,
          content: _buildIssueStep(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ШАГ 1: формат
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFormatStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите удобный формат',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...SessionFormat.values.map((format) {
          final isSelected = _selectedFormat == format;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFormat = format),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Text(format.icon, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            format.displayName,
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            format.description,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ШАГ 2: дата
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDateStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите дату',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableDates.map((date) {
            final isSelected =
                _selectedDate != null &&
                _selectedDate!.year == date.year &&
                _selectedDate!.month == date.month &&
                _selectedDate!.day == date.day;

            final months = [
              'янв',
              'фев',
              'мар',
              'апр',
              'мая',
              'июн',
              'июл',
              'авг',
              'сен',
              'окт',
              'ноя',
              'дек',
            ];
            final days = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

            return GestureDetector(
              onTap: () => setState(() => _selectedDate = date),
              child: Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // день недели
                    Text(
                      days[date.weekday - 1],
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // число
                    Text(
                      '${date.day}',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    // месяц
                    Text(
                      months[date.month - 1],
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ШАГ 3: время
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTimeStep() {
    if (_selectedDate == null) {
      return Text(
        'Сначала выберите дату',
        style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
      );
    }

    final slots = _slotsForSelectedDate;

    if (slots.isEmpty) {
      return Text(
        'Нет доступных слотов на эту дату',
        style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите время',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slots.map((slot) {
            final isSelected =
                _selectedSlot != null &&
                _selectedSlot!['startTime'] == slot['startTime'] &&
                _selectedSlot!['endTime'] == slot['endTime'];

            return GestureDetector(
              onTap: () => setState(() => _selectedSlot = slot),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${slot['startTime']} – ${slot['endTime']}',
                  style: AppTextStyles.body1.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ШАГ 4: тема + итог
  // ═══════════════════════════════════════════════════════════════
  Widget _buildIssueStep() {
    final months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'мая',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Расскажите о вашем запросе (необязательно)',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _issueController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Что вас беспокоит? С чем хотели бы поработать?',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 24),
        // ── итог ──
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Итог записи',
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('Специалист', widget.psychologistName),
              _buildSummaryRow('Формат', _selectedFormat?.displayName ?? '—'),
              _buildSummaryRow(
                'Дата',
                _selectedDate != null
                    ? '${_selectedDate!.day} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}'
                    : '—',
              ),
              _buildSummaryRow(
                'Время',
                _selectedSlot != null
                    ? '${_selectedSlot!['startTime']} – ${_selectedSlot!['endTime']}'
                    : '—',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
