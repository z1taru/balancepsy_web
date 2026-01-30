import 'package:flutter/material.dart';
import '../../../../../widgets/unified_sidebar.dart';
import '../../../../../widgets/unified_chat_widget.dart';
import '../../../../core/router/app_router.dart';

class ChatPatientPage extends StatelessWidget {
  const ChatPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280,
            child: UnifiedSidebar(currentRoute: AppRouter.chatPatient),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const UnifiedChatWidget(
                  currentUserRole: 'CLIENT',
                  currentRoute: AppRouter.chatPatient,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
