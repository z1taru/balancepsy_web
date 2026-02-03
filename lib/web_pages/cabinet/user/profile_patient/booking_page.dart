// lib/web_pages/cabinet/user/booking/booking_page.dart

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../models/session_format.dart';
import '../../../../models/available_slot.dart';
import '../../../../models/schedule_slot.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../../core/services/psychologist_service.dart';

class BookingPage extends StatefulWidget {
  final int psychologistId;
  final String psychologistName;

  const BookingPage({
    super.key,
    required this.psychologistId,
    required this.psychologistName,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ScheduleService _scheduleService = ScheduleService();
  final PsychologistService _psychologistService = PsychologistService();
  final TextEditingController _issueController = TextEditingController();

  int _currentStep = 0;
  SessionFormat? _selectedFormat;
  DateTime? _selectedDate;
  AvailableSlot? _selectedSlot;

  List<ScheduleSlot> _scheduleSlots = [];
  List<AvailableSlot> _availableSlots = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);

    try {
      final slots = await _scheduleService.getPsychologistSchedule(
        widget.psychologistId,
      );

      setState(() {
        _scheduleSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading schedule: $e');
      setState(() => _isLoading = false);
    }
  }

  List<AvailableSlot> _generateAvailableSlots() {
    if (_scheduleSlots.isEmpty) return [];

    final now = DateTime.now();
    final slots = <AvailableSlot>[];

    // Генерируем слоты на следующие 4 недели
    for (var i = 0; i < 28; i++) {
      final date = now.add(Duration(days: i));

      for (var scheduleSlot in _scheduleSlots) {
        if (date.weekday == scheduleSlot.dayOfWeek && date.isAfter(now)) {
          slots.add(
            AvailableSlot(
              date: date,
              startTime: scheduleSlot.startTime,
              endTime: scheduleSlot.endTime,
              isBooked: false, // TODO: Проверять занятость через API
            ),
          );
        }
      }
    }

    return slots;
  }

  void _submitBooking() async {
    if (_selectedFormat == null ||
        _selectedDate == null ||
        _selectedSlot == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _psychologistService.createAppointment(
        psychologistId: widget.psychologistId,
        appointmentDate:
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        startTime: _selectedSlot!.startTime,
        endTime: _selectedSlot!.endTime,
        format: _selectedFormat!.name,
        issueDescription: _issueController.text.isEmpty
            ? null
            : _issueController.text,
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Запись к ${widget.psychologistName}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep == 0 && _selectedFormat == null) return;
                if (_currentStep == 1 && _selectedDate == null) return;
                if (_currentStep == 2 && _selectedSlot == null) return;

                if (_currentStep < 3) {
                  setState(() => _currentStep++);
                } else {
                  _submitBooking();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
              controlsBuilder: (context, details) {
                final isLastStep = _currentStep == 3;
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
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
                  state: _currentStep > 0
                      ? StepState.complete
                      : StepState.indexed,
                  content: _buildFormatStep(),
                ),
                Step(
                  title: const Text('Выбор даты'),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
                  content: _buildDateStep(),
                ),
                Step(
                  title: const Text('Выбор времени'),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2
                      ? StepState.complete
                      : StepState.indexed,
                  content: _buildTimeStep(),
                ),
                Step(
                  title: const Text('Тема обращения'),
                  isActive: _currentStep >= 3,
                  state: _currentStep > 3
                      ? StepState.complete
                      : StepState.indexed,
                  content: _buildIssueStep(),
                ),
              ],
            ),
    );
  }

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

  Widget _buildDateStep() {
    _availableSlots = _generateAvailableSlots();

    // Группируем по датам
    final dateMap = <String, List<AvailableSlot>>{};
    for (var slot in _availableSlots) {
      final key = '${slot.date.year}-${slot.date.month}-${slot.date.day}';
      dateMap.putIfAbsent(key, () => []).add(slot);
    }

    final uniqueDates = dateMap.keys.map((key) {
      final parts = key.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите дату',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        if (uniqueDates.isEmpty)
          Text(
            'Нет доступных дат',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: uniqueDates.map((date) {
              final isSelected =
                  _selectedDate != null &&
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
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
                    '${date.day}.${date.month.toString().padLeft(2, '0')}',
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

  Widget _buildTimeStep() {
    if (_selectedDate == null) {
      return Text(
        'Сначала выберите дату',
        style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
      );
    }

    final slotsForDate = _availableSlots.where((slot) {
      return slot.date.year == _selectedDate!.year &&
          slot.date.month == _selectedDate!.month &&
          slot.date.day == _selectedDate!.day;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите время',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        if (slotsForDate.isEmpty)
          Text(
            'Нет доступных слотов на эту дату',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: slotsForDate.map((slot) {
              final isSelected = _selectedSlot == slot;

              return GestureDetector(
                onTap: slot.isBooked
                    ? null
                    : () => setState(() => _selectedSlot = slot),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: slot.isBooked
                        ? AppColors.textTertiary.withOpacity(0.1)
                        : isSelected
                        ? AppColors.primary
                        : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: slot.isBooked
                          ? AppColors.textTertiary
                          : isSelected
                          ? AppColors.primary
                          : AppColors.inputBorder.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${slot.startTime} - ${slot.endTime}',
                    style: AppTextStyles.body1.copyWith(
                      color: slot.isBooked
                          ? AppColors.textTertiary
                          : isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      decoration: slot.isBooked
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildIssueStep() {
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
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Что вас беспокоит? С чем хотели бы поработать?',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Итого:', style: AppTextStyles.h3.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              _buildSummaryRow('Формат', _selectedFormat?.displayName ?? '—'),
              _buildSummaryRow(
                'Дата',
                _selectedDate != null
                    ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
                    : '—',
              ),
              _buildSummaryRow(
                'Время',
                _selectedSlot != null
                    ? '${_selectedSlot!.startTime} - ${_selectedSlot!.endTime}'
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
      padding: const EdgeInsets.only(bottom: 8),
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
