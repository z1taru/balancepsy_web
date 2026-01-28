// lib/web_pages/profile_patient/sessions_calendar.dart

import 'package:flutter/material.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../theme/app_colors.dart';

class SessionsCalendarPage extends StatefulWidget {
  const SessionsCalendarPage({super.key});

  @override
  State<SessionsCalendarPage> createState() => _SessionsCalendarPageState();
}

class _SessionsCalendarPageState extends State<SessionsCalendarPage> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    // Здесь можно добавить логику сохранения/передачи выбранной даты
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Выбрана дата: ${_formatDate(date)}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // РУЧНОЕ ФОРМАТИРОВАНИЕ — РАБОТАЕТ В WEB
  String _formatMonthYear(DateTime date) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatWeekday(int weekday) {
    const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return weekdays[weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Text(
              'Выберите дату сессии',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 24),

            // Месяц + стрелки
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  _formatMonthYear(_currentMonth),
                  style: AppTextStyles.h3,
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Дни недели
            Row(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Center(
                    child: Text(
                      _formatWeekday(index + 1),
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Сетка дней
            LayoutBuilder(
              builder: (context, constraints) {
                final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
                final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
                final startingWeekday = firstDayOfMonth.weekday; // 1 = Понедельник

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: daysInMonth + startingWeekday - 1,
                  itemBuilder: (context, index) {
                    if (index < startingWeekday - 1) {
                      return const SizedBox.shrink(); // Пустые ячейки
                    }

                    final day = index - startingWeekday + 2;
                    final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                    final isToday = date.year == DateTime.now().year &&
                        date.month == DateTime.now().month &&
                        date.day == DateTime.now().day;
                    final isSelected = _selectedDate != null &&
                        date.year == _selectedDate!.year &&
                        date.month == _selectedDate!.month &&
                        date.day == _selectedDate!.day;

                    return GestureDetector(
                      onTap: () => _selectDate(date),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : isToday
                                  ? AppColors.primary.withOpacity(0.1)
                                  : null,
                          borderRadius: BorderRadius.circular(12),
                          border: isToday
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: AppTextStyles.body1.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                              fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Кнопки
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Отмена',
                    style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedDate == null
                      ? null
                      : () {
                          Navigator.pop(context, _selectedDate);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Выбрать',
                    style: AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}