import 'chat_message.dart';

enum UserMode { guest, client, psychologist }

class ChatSession {
  final String sessionId;
  final UserMode userMode;
  final String? userId;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageLimit; // Для гостей

  ChatSession({
    required this.sessionId,
    required this.userMode,
    this.userId,
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
    this.messageLimit = 3,
  });

  factory ChatSession.guest() {
    final now = DateTime.now();
    return ChatSession(
      sessionId: 'guest_${now.millisecondsSinceEpoch}',
      userMode: UserMode.guest,
      userId: null,
      messages: [],
      createdAt: now,
      updatedAt: now,
      messageLimit: 3,
    );
  }

  factory ChatSession.authenticated({
    required String userId,
    required UserMode userMode,
  }) {
    final now = DateTime.now();
    return ChatSession(
      sessionId: '${userMode.name}_${userId}_${now.millisecondsSinceEpoch}',
      userMode: userMode,
      userId: userId,
      messages: [],
      createdAt: now,
      updatedAt: now,
      messageLimit: 999, // Без лимита для авторизованных
    );
  }

  bool get isGuest => userMode == UserMode.guest;
  bool get isAuthenticated => userId != null;

  int get userMessageCount =>
      messages.where((m) => m.role == ChatMessageRole.user).length;

  bool get canSendMessage => userMessageCount < messageLimit;

  int get remainingMessages => messageLimit - userMessageCount;

  ChatSession copyWith({
    String? sessionId,
    UserMode? userMode,
    String? userId,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageLimit,
  }) {
    return ChatSession(
      sessionId: sessionId ?? this.sessionId,
      userMode: userMode ?? this.userMode,
      userId: userId ?? this.userId,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageLimit: messageLimit ?? this.messageLimit,
    );
  }

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'userMode': userMode.name,
    'userId': userId,
    'messages': messages.map((m) => m.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'messageLimit': messageLimit,
  };

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json['sessionId'],
      userMode: UserMode.values.firstWhere(
        (e) => e.name == json['userMode'],
        orElse: () => UserMode.guest,
      ),
      userId: json['userId'],
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      messageLimit: json['messageLimit'] ?? 3,
    );
  }
}
