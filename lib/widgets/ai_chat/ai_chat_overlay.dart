import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'floating_ai_button.dart';
import 'mini_chat.dart';

class AiChatOverlay extends StatefulWidget {
  final Widget child;

  const AiChatOverlay({super.key, required this.child});

  @override
  State<AiChatOverlay> createState() => _AiChatOverlayState();
}

class _AiChatOverlayState extends State<AiChatOverlay> {
  bool _isChatOpen = false;

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  void _closeChat() {
    setState(() {
      _isChatOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Основной контент
        widget.child,

        // Overlay с чатом
        if (_isChatOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeChat,
              child: Container(
                color: Colors.black26,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {}, // Предотвращаем закрытие при клике на панель
                    child: MiniChatPanel(onClose: _closeChat),
                  ),
                ),
              ),
            ),
          ),

        // Плавающая кнопка
        Positioned(
          right: 20,
          bottom: 20,
          child: Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return FloatingAiButton(
                onPressed: _toggleChat,
                unreadCount: 0, // TODO: подсчет непрочитанных
              );
            },
          ),
        ),
      ],
    );
  }
}