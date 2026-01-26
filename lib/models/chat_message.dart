enum ChatMessageRole {
  user,
  assistant,
  system,
}

class ChatMessage {
  final String id;
  final ChatMessageRole role;
  final String content;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatMessageRole.user,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.assistant(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatMessageRole.assistant,
      content: content,
      timestamp: DateTime.now(),
    );
  }

  factory ChatMessage.loading() {
    return ChatMessage(
      id: 'loading',
      role: ChatMessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
      isLoading: true,
    );
  }

  factory ChatMessage.error(String errorMessage) {
    return ChatMessage(
      id: 'error',
      role: ChatMessageRole.assistant,
      content: errorMessage,
      timestamp: DateTime.now(),
      error: errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      role: ChatMessageRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => ChatMessageRole.user,
      ),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  ChatMessage copyWith({
    String? id,
    ChatMessageRole? role,
    String? content,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}