// lib/models/session_format.dart

enum SessionFormat {
  VIDEO,
  CHAT,
  AUDIO;

  String get displayName {
    switch (this) {
      case SessionFormat.VIDEO:
        return 'Видеоконсультация';
      case SessionFormat.CHAT:
        return 'Чат';
      case SessionFormat.AUDIO:
        return 'Аудиоконсультация';
    }
  }

  String get icon {
    switch (this) {
      case SessionFormat.VIDEO:
        return '📹';
      case SessionFormat.CHAT:
        return '💬';
      case SessionFormat.AUDIO:
        return '🎧';
    }
  }

  String get description {
    switch (this) {
      case SessionFormat.VIDEO:
        return 'Видеозвонок с психологом';
      case SessionFormat.CHAT:
        return 'Текстовая переписка';
      case SessionFormat.AUDIO:
        return 'Голосовой звонок';
    }
  }
}
