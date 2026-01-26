import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'floating_ai_button.dart';
import 'mini_chat.dart';

class ChatOverlayWidget extends StatefulWidget {
  final Widget child;

  const ChatOverlayWidget({super.key, required this.child});

  @override
  State<ChatOverlayWidget> createState() => _ChatOverlayWidgetState();
}

class _ChatOverlayWidgetState extends State<ChatOverlayWidget> {
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
        widget.child,
        if (_isChatOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeChat,
              child: Container(
                color: Colors.black26,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {},
                    child: ChatContainer(onClose: _closeChat),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          right: 20,
          bottom: 20,
          child: Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return FloatingAiButton(onPressed: _toggleChat, unreadCount: 0);
            },
          ),
        ),
      ],
    );
  }
}

class AiChatOverlay extends StatefulWidget {
  final Widget child;

  const AiChatOverlay({super.key, required this.child});

  @override
  State<AiChatOverlay> createState() => _AiChatOverlayState();
}

class _AiChatOverlayState extends State<AiChatOverlay> {
  @override
  Widget build(BuildContext context) {
    return ChatOverlayWidget(child: widget.child);
  }
}
