import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/ai_chat/chat_message_bubble.dart';
import '../../widgets/ai_chat/chat_input_field.dart';
import '../../widgets/page_wrapper.dart';

class FullChatScreen extends StatefulWidget {
  const FullChatScreen({super.key});

  @override
  State<FullChatScreen> createState() => _FullChatScreenState();
}

class _FullChatScreenState extends State<FullChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return PageWrapper(
      currentRoute: '/ai-chat',
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          // Auto-scroll при новых сообщениях
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 0 : 40,
              vertical: isMobile ? 0 : 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
              boxShadow: isMobile
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              children: [
                _buildHeader(context, chatProvider, isMobile),
                Expanded(
                  child: Row(
                    children: [
                      // Сайдбар с историей (только для desktop)
                      if (!isMobile) _buildHistorySidebar(chatProvider),
                      // Основной чат
                      Expanded(
                        child: chatProvider.hasSession
                            ? _buildChatContent(chatProvider)
                            : _buildEmptyState(),
                      ),
                    ],
                  ),
                ),
                ChatInputField(
                  onSend: (text) => chatProvider.sendMessage(text),
                  isEnabled: chatProvider.canSendMessage &&
                      chatProvider.isAiAvailable,
                  remainingMessages: chatProvider.remainingMessages,
                  isGuest: chatProvider.isGuest,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, ChatProvider chatProvider, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
          ),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isMobile ? 0 : 24),
        ),
      ),
      child: Row(
        children: [
          // Назад (только mobile)
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Ассистент', style: AppTextStyles.h3),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: chatProvider.isAiAvailable
                            ? AppColors.success
                            : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      chatProvider.isAiAvailable ? 'Онлайн' : 'Недоступен',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (chatProvider.isGuest) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Гостевой режим',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Новый диалог',
            onPressed: () => _showNewChatConfirmation(context, chatProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySidebar(ChatProvider chatProvider) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(
          right: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('История диалогов', style: AppTextStyles.h4),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: chatProvider.getHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'История пуста',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final session = snapshot.data![index];
                    return _buildHistoryItem(chatProvider, session);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ChatProvider chatProvider, dynamic session) {
    final isActive =
        chatProvider.currentSession?.sessionId == session.sessionId;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(
          Icons.chat_bubble_outline,
          size: 20,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          _getSessionTitle(session),
          style: AppTextStyles.body2.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDate(session.updatedAt),
          style: AppTextStyles.caption.copyWith(fontSize: 11),
        ),
        onTap: () => chatProvider.loadSession(session),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 18),
          onPressed: () => chatProvider.deleteSession(session.sessionId),
        ),
      ),
    );
  }

  Widget _buildChatContent(ChatProvider chatProvider) {
    final messages = chatProvider.messages;

    if (messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatMessageBubble(message: messages[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 100,
            color: AppColors.primary.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          Text(
            'Начните общение с AI',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'Задайте любой вопрос о психологии, нашей платформе или получите рекомендации',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getSessionTitle(dynamic session) {
    if (session.messages.length > 1) {
      // Берем первое сообщение пользователя
      final userMessage = session.messages.firstWhere(
        (m) => m.role.name == 'user',
        orElse: () => session.messages[1],
      );
      return userMessage.content.length > 30
          ? '${userMessage.content.substring(0, 30)}...'
          : userMessage.content;
    }
    return 'Новый диалог';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Сегодня';
    if (diff.inDays == 1) return 'Вчера';
    if (diff.inDays < 7) return '${diff.inDays} дн. назад';

    return '${date.day}.${date.month}.${date.year}';
  }

  void _showNewChatConfirmation(
      BuildContext context, ChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый диалог'),
        content: const Text(
          'Начать новый диалог? Текущая история будет сохранена.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              chatProvider.startNewChat();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Начать'),
          ),
        ],
      ),
    );
  }
}