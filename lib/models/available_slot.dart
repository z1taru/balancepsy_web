// lib/models/available_slot.dart

class AvailableSlot {
  final DateTime date;
  final String startTime;
  final String endTime;
  final bool isBooked;

  AvailableSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  String get displayDate {
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
    return '${date.day} ${months[date.month - 1]}';
  }

  String get displayTime => '$startTime - $endTime';

  String get weekday {
    const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return weekdays[date.weekday - 1];
  }
}
