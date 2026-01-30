// lib/widgets/unified_chat_widget.dart2

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../core/services/chat_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Универсальный виджет чата для клиента и психолога
class UnifiedChatWidget extends StatefulWidget {
  final String currentUserRole; // CLIENT или PSYCHOLOGIST
  final String currentRoute;

  const UnifiedChatWidget({
    super.key,
    required this.currentUserRole,
    required this.currentRoute,
  });

  @override
  State<UnifiedChatWidget> createState() => _UnifiedChatWidgetState();
}

class _UnifiedChatWidgetState extends State<UnifiedChatWidget> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  Map<String, dynamic>? _selectedChat;
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);

    try {
      final chats = await _chatService.getUserChats();
      setState(() {
        _chats = chats;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading chats: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMessages(Map<String, dynamic> chat) async {
    try {
      final messages = await _chatService.getChatMessages(chat['id']);
      setState(() {
        _messages = messages;
        _selectedChat = chat;
      });
      _scrollToBottom();

      await _chatService.markMessagesAsRead(chat['id']);
    } catch (e) {
      print('❌ Error loading messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _selectedChat == null) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      final newMessage = await _chatService.sendMessage(
        chatRoomId: _selectedChat!['id'],
        text: messageText,
        messageType: 'text',
      );

      setState(() {
        _messages.add(newMessage);
      });

      _scrollToBottom();
    } catch (e) {
      print('❌ Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось отправить сообщение: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Row(
      children: [
        _buildChatsList(),
        Expanded(
          child: _selectedChat != null ? _buildChatArea() : _buildEmptyState(),
        ),
      ],
    );
  }

  Widget _buildChatsList() {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppColors.inputBorder.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          _buildChatsHeader(),
          Expanded(
            child: _chats.isEmpty
                ? _buildEmptyChatsState()
                : ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return _buildChatItem(chat);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.currentUserRole == 'PSYCHOLOGIST' ? 'Клиенты' : 'Психологи',
            style: AppTextStyles.h2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Поиск...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              // TODO: Implement search
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Нет активных чатов',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final isSelected = _selectedChat?['id'] == chat['id'];
    final partnerName = chat['partnerName'] ?? 'Пользователь';
    final partnerImage = chat['partnerImage'];
    final lastMessage = chat['lastMessage'] ?? '';
    final lastMessageTime = chat['lastMessageTime'];
    final unreadCount = chat['unreadCount'] ?? 0;
    final isOnline = chat['isPartnerOnline'] ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _loadMessages(chat),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.05)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  _buildAvatar(partnerImage),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            partnerName,
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (lastMessageTime != null)
                          Text(
                            _formatTime(lastMessageTime),
                            style: AppTextStyles.body3.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: AppTextStyles.body3.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: [
        _buildChatHeader(),
        Expanded(
          child: Container(
            color: AppColors.backgroundLight,
            child: _messages.isEmpty
                ? _buildEmptyMessagesState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildChatHeader() {
    final partnerName = _selectedChat!['partnerName'] ?? 'Пользователь';
    final partnerImage = _selectedChat!['partnerImage'];
    final isOnline = _selectedChat!['isPartnerOnline'] ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(partnerImage, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerName,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.success
                            : AppColors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOnline ? 'онлайн' : 'не в сети',
                      style: AppTextStyles.body3.copyWith(
                        color: isOnline
                            ? AppColors.success
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Видеозвонок только для психолога
          if (widget.currentUserRole == 'PSYCHOLOGIST')
            IconButton(
              icon: const Icon(Icons.videocam_outlined),
              onPressed: () async {
                try {
                  final zvondaUrl = await _chatService.getZvondaUrl(
                    _selectedChat!['id'],
                  );
                  // TODO: Open video call
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ссылка на видео: $zvondaUrl')),
                  );
                } catch (e) {
                  print('❌ Error getting Zvonda URL: $e');
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                foregroundColor: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessagesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_outlined,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Нет сообщений',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['senderId'] != _selectedChat!['partnerId'];
    final text = message['text'] ?? '';
    final createdAt = message['createdAt'];
    final senderImage = message['senderImage'];
    final messageType = message['type'] ?? 'TEXT';
    final attachmentUrl = message['attachmentUrl'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _buildAvatar(senderImage, size: 32),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: !isMe
                    ? [
                        BoxShadow(
                          color: AppColors.shadow.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Отображение изображения
                  if (messageType == 'IMAGE' && attachmentUrl != null) ...[
                    _buildImagePreview(attachmentUrl),
                    const SizedBox(height: 8),
                  ],
                  // Отображение файла
                  if (messageType == 'FILE' && attachmentUrl != null) ...[
                    _buildFilePreview(message),
                    const SizedBox(height: 8),
                  ],
                  // Текст сообщения
                  Text(
                    text,
                    style: AppTextStyles.body1.copyWith(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  if (createdAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(createdAt),
                      style: AppTextStyles.body3.copyWith(
                        color: isMe
                            ? Colors.white.withOpacity(0.7)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    final fullUrl = 'http://localhost:8055/assets/$imageUrl'; // Directus URL

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: fullUrl,
        width: 200,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 200,
          height: 150,
          color: AppColors.inputBackground,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          width: 200,
          height: 150,
          color: AppColors.inputBackground,
          child: const Icon(Icons.broken_image, size: 48),
        ),
      ),
    );
  }

  Widget _buildFilePreview(Map<String, dynamic> message) {
    final fileName = message['attachmentName'] ?? 'Файл';
    final fileSize = message['attachmentSize'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (fileSize != null)
                Text(
                  _formatFileSize(fileSize),
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.inputBorder.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Напишите сообщение...',
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: AppColors.backgroundLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text('Выберите чат', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Text(
              widget.currentUserRole == 'PSYCHOLOGIST'
                  ? 'Начните общение с вашим клиентом'
                  : 'Начните общение с вашим психологом',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl, {double size = 56}) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final fullUrl = 'http://localhost:8055/assets/$imageUrl';

      return CircleAvatar(
        radius: size / 2,
        backgroundImage: CachedNetworkImageProvider(fullUrl),
        onBackgroundImageError: (_, __) {},
        child: Container(),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Icon(Icons.person, size: size * 0.6, color: AppColors.primary),
    );
  }

  String _formatTime(dynamic dateTime) {
    if (dateTime == null) return '';

    try {
      DateTime dt;
      if (dateTime is String) {
        dt = DateTime.parse(dateTime);
      } else if (dateTime is DateTime) {
        dt = dateTime;
      } else {
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(dt);

      if (difference.inDays == 0) {
        return DateFormat('HH:mm').format(dt);
      } else if (difference.inDays == 1) {
        return 'Вчера';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} дн.';
      } else {
        return DateFormat('dd.MM').format(dt);
      }
    } catch (e) {
      return '';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
