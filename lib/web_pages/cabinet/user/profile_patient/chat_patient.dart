// lib/web_pages/profile_patient/chat_patient.dart

import 'package:balance_psy/widgets/unified_sidebar.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/page_wrapper.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../сore/router/app_router.dart';

class ChatPatientPage extends StatefulWidget {
  const ChatPatientPage({super.key});

  @override
  State<ChatPatientPage> createState() => _ChatPatientPageState();
}

class _ChatPatientPageState extends State<ChatPatientPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Chat> _chats = [
    Chat(
      id: '1',
      psychologistName: 'Галия Аубакирова',
      lastMessage: 'Как ваше самочувствие после нашей последней сессии?',
      timestamp: '10:30',
      unreadCount: 2,
      isOnline: true,
      avatar: 'assets/images/avatar/galiya.png',
    ),
    Chat(
      id: '2',
      psychologistName: 'Яна Прозорова',
      lastMessage: 'Не забудьте выполнить упражнение из дневника',
      timestamp: 'Вчера',
      unreadCount: 0,
      isOnline: false,
      avatar: 'assets/images/avatar/yana2.png',
    ),
    Chat(
      id: '3',
      psychologistName: 'Лаура Болдина',
      lastMessage: 'Перенесем сессию на завтра в 16:00?',
      timestamp: 'Пн',
      unreadCount: 1,
      isOnline: false,
      status: 'занята',
      avatar: 'assets/images/avatar/laura2.png',
    ),
  ];

  Chat? _selectedChat;
  final Map<String, List<Message>> _chatMessages = {};

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() {
    _chatMessages['1'] = [
      Message(
        text: 'Здравствуйте! Как ваше самочувствие сегодня?',
        time: '10:25',
        isMe: false,
      ),
      Message(
        text: 'Добрый день! В целом нормально, но немного тревожно',
        time: '10:26',
        isMe: true,
      ),
      Message(
        text: 'Это нормально. Давайте обсудим это на нашей следующей сессии. Не забудьте записывать свои мысли в дневник',
        time: '10:30',
        isMe: false,
      ),
      Message(
        text: 'Хорошо, обязательно запишу. Спасибо за поддержку!',
        time: '10:31',
        isMe: true,
      ),
    ];

    _chatMessages['2'] = [
      Message(
        text: 'Добрый день! Как прошла неделя?',
        time: '14:20',
        isMe: false,
      ),
      Message(
        text: 'Здравствуйте! Неделя была непростой',
        time: '14:25',
        isMe: true,
      ),
    ];

    _chatMessages['3'] = [
      Message(
        text: 'Здравствуйте! У меня появилось свободное время завтра',
        time: '09:15',
        isMe: false,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фиксированный сайдбар, который не скролится
          Container(
            width: 280,
            child: UnifiedSidebar(currentRoute: AppRouter.chatPatient),
          ),
          // Основной контент с возможностью скролла
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildChatContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent() {
    return Row(
      children: [
        Container(
          width: 400,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: AppColors.inputBorder.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildChatsHeader(),
              Expanded(
                child: ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    return _buildChatListItem(chat);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedChat != null 
              ? _buildChatArea(_selectedChat!)
              : _buildEmptyChatState(),
        ),
      ],
    );
  }

  Widget _buildChatsHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Мои психологи', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск сообщений...',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatListItem(Chat chat) {
    final isSelected = _selectedChat?.id == chat.id;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedChat = chat;
            if (chat.unreadCount > 0) {
              final index = _chats.indexWhere((c) => c.id == chat.id);
              _chats[index] = Chat(
                id: chat.id,
                psychologistName: chat.psychologistName,
                lastMessage: chat.lastMessage,
                timestamp: chat.timestamp,
                unreadCount: 0,
                isOnline: chat.isOnline,
                status: chat.status,
                avatar: chat.avatar,
              );
            }
          });
          _scrollToBottom();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: AppColors.inputBorder.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(chat.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (chat.isOnline)
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chat.psychologistName,
                          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          chat.timestamp,
                          style: AppTextStyles.body3.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat.lastMessage,
                            style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: AppTextStyles.body3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _getStatusColor(chat),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(chat),
                          style: AppTextStyles.body3.copyWith(
                            color: _getStatusColor(chat),
                            fontSize: 11,
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

  Color _getStatusColor(Chat chat) {
    if (chat.status == 'занята') return Colors.orange;
    if (chat.isOnline) return AppColors.success;
    return AppColors.textTertiary;
  }

  String _getStatusText(Chat chat) {
    if (chat.status != null) return chat.status!;
    if (chat.isOnline) return 'онлайн';
    return 'не в сети';
  }

  Widget _buildChatArea(Chat chat) {
    final messages = _chatMessages[chat.id] ?? [];
    
    return Column(
      children: [
        _buildChatHeader(chat),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length - 1 - index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildChatHeader(Chat chat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(chat.avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (chat.isOnline && chat.status != 'занята')
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.psychologistName,
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  _getStatusText(chat),
                  style: AppTextStyles.body3.copyWith(color: _getStatusColor(chat)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Информация о психологе - скоро будет доступно'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(Icons.info_outline, color: AppColors.textSecondary),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Видеозвонок - скоро будет доступно'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(Icons.videocam_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
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
            child: Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text('Выберите чат', style: AppTextStyles.h2),
          const SizedBox(height: 12),
          Text(
            'Начните общение с вашим психологом',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.isMe;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(_selectedChat?.avatar ?? 'assets/images/avatar/galiya.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.inputBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTextStyles.body1.copyWith(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: AppTextStyles.body3.copyWith(
                      color: isMe ? Colors.white.withOpacity(0.7) : AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Прикрепление файлов - скоро будет доступно'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(Icons.attach_file, color: AppColors.textSecondary),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Написать сообщение...',
                  hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _sendMessage,
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _selectedChat == null) return;

    setState(() {
      final newMessage = Message(
        text: _messageController.text.trim(),
        time: _getCurrentTime(),
        isMe: true,
      );

      _chatMessages[_selectedChat!.id]?.add(newMessage);

      // Update last message in chat list
      final index = _chats.indexWhere((c) => c.id == _selectedChat!.id);
      _chats[index] = Chat(
        id: _selectedChat!.id,
        psychologistName: _selectedChat!.psychologistName,
        lastMessage: _messageController.text.trim(),
        timestamp: 'Сейчас',
        unreadCount: 0,
        isOnline: _selectedChat!.isOnline,
        status: _selectedChat!.status,
        avatar: _selectedChat!.avatar,
      );

      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

class Chat {
  final String id;
  final String psychologistName;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;
  final String? status;
  final String avatar;

  Chat({
    required this.id,
    required this.psychologistName,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
    this.status,
    required this.avatar,
  });
}

class Message {
  final String text;
  final String time;
  final bool isMe;

  Message({
    required this.text,
    required this.time,
    required this.isMe,
  });
}