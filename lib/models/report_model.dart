// lib/models/report_model.dart

enum ReportStatus {
  completed, // ✅ Готов
  draft, // 🟡 Черновик
  pending, // ⚠️ Требуется заполнить
}

class ReportModel {
  final int id;
  final int appointmentId;
  final int clientId;
  final String clientName;
  final String? clientAvatarUrl;
  final DateTime sessionDate;
  final String sessionFormat;
  final String sessionTheme;
  final String sessionDescription;
  final String? recommendations;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  ReportModel({
    required this.id,
    required this.appointmentId,
    required this.clientId,
    required this.clientName,
    this.clientAvatarUrl,
    required this.sessionDate,
    required this.sessionFormat,
    required this.sessionTheme,
    required this.sessionDescription,
    this.recommendations,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int,
      appointmentId: json['appointmentId'] as int,
      clientId: json['clientId'] as int,
      clientName: json['clientName'] as String,
      clientAvatarUrl: json['clientAvatarUrl'] as String?,
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      sessionFormat: json['sessionFormat'] as String,
      sessionTheme: json['sessionTheme'] as String,
      sessionDescription: json['sessionDescription'] as String,
      recommendations: json['recommendations'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  ReportStatus get status {
    if (isCompleted) {
      return ReportStatus.completed;
    }

    // Если есть тема и описание - это черновик
    if (sessionTheme.isNotEmpty && sessionDescription.isNotEmpty) {
      return ReportStatus.draft;
    }

    // Иначе требуется заполнить
    return ReportStatus.pending;
  }

  String get statusText {
    switch (status) {
      case ReportStatus.completed:
        return 'Готов';
      case ReportStatus.draft:
        return 'Черновик';
      case ReportStatus.pending:
        return 'Требуется заполнить';
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDay = DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
    );

    if (sessionDay == today) {
      return 'Сегодня';
    } else if (sessionDay == yesterday) {
      return 'Вчера';
    } else {
      // Используем простое форматирование без локали
      final months = [
        '',
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
      return '${sessionDate.day} ${months[sessionDate.month]} ${sessionDate.year}';
    }
  }

  String get formattedCreatedAt {
    final months = [
      '',
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
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '${createdAt.day} ${months[createdAt.month]} ${createdAt.year}, $hour:$minute';
  }

  String get formattedCompletedAt {
    if (completedAt == null) return '—';
    final months = [
      '',
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
    final hour = completedAt!.hour.toString().padLeft(2, '0');
    final minute = completedAt!.minute.toString().padLeft(2, '0');
    return '${completedAt!.day} ${months[completedAt!.month]} ${completedAt!.year}, $hour:$minute';
  }
}

/// Группа отчётов по дате
class ReportGroupByDate {
  final DateTime date;
  final List<ReportModel> reports;

  ReportGroupByDate({required this.date, required this.reports});

  int get clientCount => reports.map((r) => r.clientId).toSet().length;
  int get sessionCount => reports.length;

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final reportDay = DateTime(date.year, date.month, date.day);

    if (reportDay == today) {
      return 'Сегодня';
    } else if (reportDay == yesterday) {
      return 'Вчера';
    } else {
      final months = [
        '',
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
      return '${date.day} ${months[date.month]} ${date.year}';
    }
  }
}
