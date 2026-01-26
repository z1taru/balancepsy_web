import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool isEnabled;
  final int? remainingMessages;
  final bool isGuest;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.isEnabled = true,
    this.remainingMessages,
    this.isGuest = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.inputBorder.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isGuest && widget.remainingMessages != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.remainingMessages! > 0
                            ? 'Осталось ${widget.remainingMessages} ${_getMessageWord(widget.remainingMessages!)}'
                            : 'Лимит исчерпан. Зарегистрируйтесь для продолжения',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.isEnabled,
                    maxLines: null,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: widget.isEnabled
                          ? 'Напишите сообщение...'
                          : 'AI недоступен',
                      hintStyle: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.inputBorder.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                    ),
                    style: AppTextStyles.body2,
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                _buildSendButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final hasText = _controller.text.trim().isNotEmpty;
    final canSend = hasText && widget.isEnabled;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: canSend ? AppColors.primary : AppColors.inputBorder,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canSend ? _handleSend : null,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  String _getMessageWord(int count) {
    if (count == 1) return 'сообщение';
    if (count < 5) return 'сообщения';
    return 'сообщений';
  }
}
