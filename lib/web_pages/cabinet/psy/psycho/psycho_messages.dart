import 'package:flutter/material.dart';
import '../../../../widgets/unified_sidebar.dart';
import '../../../../widgets/unified_chat_widget.dart';
import '../../../../core/router/app_router.dart';

class PsychoMessagesPage extends StatelessWidget {
  const PsychoMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          UnifiedSidebar(currentRoute: AppRouter.psychoMessages),
          const Expanded(
            child: UnifiedChatWidget(
              currentUserRole: 'PSYCHOLOGIST',
              currentRoute: AppRouter.psychoMessages,
            ),
          ),
        ],
      ),
    );
  }
}
