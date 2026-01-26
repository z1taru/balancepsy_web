import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'chat_message_bubble.dart';
import 'chat_input_field.dart';

class ChatContainer extends StatefulWidget {
  final VoidCallback onClose;

  const ChatContainer({super.key, required this.onClose});

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
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
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        final media = MediaQuery.of(context);
        final maxHeight = media.size.height * 0.8;
        final maxWidth = media.size.width < 768 ? media.size.width : 520.0;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
          child: SafeArea(
            top: false,
            child: Material(
              color: Colors.white,
              elevation: 16,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                  maxWidth: maxWidth,
                ),
                child: SizedBox(
                  width: maxWidth,
                  child: Column(
                    children: [
                      _buildHeader(context, chatProvider),
                      Expanded(
                        child: chatProvider.hasSession
                            ? _buildChatContent(chatProvider)
                            : _buildEmptyState(),
                      ),
                      ChatInputField(
                        onSend: (text) => chatProvider.sendMessage(text),
                        isEnabled:
                            chatProvider.canSendMessage &&
                            chatProvider.isAiAvailable,
                        remainingMessages: chatProvider.remainingMessages,
                        isGuest: chatProvider.isGuest,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ChatProvider chatProvider) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Ассистент', style: AppTextStyles.h4),
                Text(
                  chatProvider.isAiAvailable ? 'Онлайн' : 'Недоступен',
                  style: AppTextStyles.caption.copyWith(
                    color: chatProvider.isAiAvailable
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_full, size: 20),
            tooltip: 'Открыть полный экран',
            onPressed: () {
              widget.onClose();
              Navigator.pushNamed(context, '/ai-chat');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Новый диалог',
            onPressed: () => _showNewChatConfirmation(context, chatProvider),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.onClose,
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 16),
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
            size: 64,
            color: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Начните диалог',
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Задайте вопрос AI-ассистенту',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewChatConfirmation(
    BuildContext context,
    ChatProvider chatProvider,
  ) {
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
            child: const Text('Начать'),
          ),
        ],
      ),
    );
  }
}

class MiniChatPanel extends StatelessWidget {
  final VoidCallback onClose;

  const MiniChatPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ChatContainer(onClose: onClose);
  }
}
