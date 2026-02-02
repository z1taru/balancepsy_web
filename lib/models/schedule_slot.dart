// lib/models/schedule_slot.dart

class ScheduleSlot {
  final int id;
  final int psychologistId;
  final int dayOfWeek; // 1-7 (Пн-Вс)
  final String startTime; // "09:00"
  final String endTime; // "10:00"
  final bool isActive;

  ScheduleSlot({
    required this.id,
    required this.psychologistId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
  });

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ScheduleSlot(
      id: json['id'] as int,
      psychologistId: json['psychologistId'] as int,
      dayOfWeek: json['dayOfWeek'] as int,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'psychologistId': psychologistId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
    };
  }

  String getDayName() {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[dayOfWeek - 1];
  }
}
