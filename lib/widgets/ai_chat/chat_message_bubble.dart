// lib/widgets/ai_chat/chat_message_bubble.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/chat_message.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatMessageRole.user;
    final isLoading = message.isLoading;
    final hasError = message.error != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[_buildAvatar(isUser), const SizedBox(width: 8)],
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : (hasError
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.backgroundLight),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 16 : 4),
                  topRight: Radius.circular(isUser ? 4 : 16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
                border: hasError
                    ? Border.all(color: AppColors.error.withOpacity(0.3))
                    : null,
              ),
              child: isLoading
                  ? _buildLoadingIndicator()
                  : _buildMessageContent(isUser, hasError),
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), _buildAvatar(isUser)],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        size: 18,
        color: isUser ? AppColors.primary : AppColors.primary.withOpacity(0.7),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Думаю...',
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(bool isUser, bool hasError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          message.content,
          style: AppTextStyles.body2.copyWith(
            color: isUser
                ? Colors.white
                : (hasError ? AppColors.error : AppColors.textPrimary),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(message.timestamp),
              style: AppTextStyles.caption.copyWith(
                color: isUser
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            if (!isUser && !hasError && !message.isLoading) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _copyToClipboard(message.content),
                child: Icon(
                  Icons.copy,
                  size: 14,
                  color: AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
