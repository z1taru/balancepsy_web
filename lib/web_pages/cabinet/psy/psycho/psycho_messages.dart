// lib/web_pages/psycho/psycho_messages.dart

import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/psycho/psycho_sidebar.dart';

class PsychoMessagesPage extends StatelessWidget {
  const PsychoMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          PsychoSidebar(currentRoute: '/psycho/messages'),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Row(
                    children: [
                      _buildClientsList(),
                      _buildChatArea(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Чаты', style: AppTextStyles.h1.copyWith(fontSize: 28)),
          Text('Мои клиенты', style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildClientsList() {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.inputBorder.withOpacity(0.3))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск клиентов...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildClientItem(
                  'Альдияр Байдилла',
                  'Вы: Добро пожаловать на сессию!',
                  '15:30',
                  'assets/images/avatar/aldiyar.png',
                  true,
                  1,
                ),
                _buildClientItem(
                  'Рамина Канатовна',
                  'Рамина: Спасибо за консультацию',
                  '14:15',
                  'assets/images/avatar/ramina.png',
                  false,
                  0,
                ),
                _buildClientItem(
                  'Ажар Алимбет',
                  'Вы: Напомните о следующей сессии',
                  '12:45',
                  'assets/images/avatar/azhar.png',
                  true,
                  0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientItem(String name, String lastMessage, String time, String avatar, bool isOnline, int unreadCount) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.1))),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(avatar),
                    onBackgroundImageError: (_, __) {
                      // Placeholder если изображение не загрузилось
                    },
                  ),
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
                    Text(name, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(time, style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary)),
                  if (unreadCount > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return Expanded(
      child: Column(
        children: [
          _buildChatHeader(),
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: const AssetImage('assets/images/avatar/aldiyar.png'),
            onBackgroundImageError: (_, __) {
              // Placeholder если изображение не загрузилось
            },
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Альдияр Байдилла', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('онлайн', style: AppTextStyles.body3.copyWith(color: AppColors.success)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMessage('Альдияр Байдилла', 'Добрый день! Готов к нашей сессии.', '15:25', false),
        _buildMessage('Вы', 'Добро пожаловать, Альдияр! Как ваше настроение сегодня?', '15:26', true),
        _buildMessage('Альдияр Байдилла', 'Спасибо, настроение хорошее. Хочу обсудить свою тревожность.', '15:27', false),
      ],
    );
  }

  Widget _buildMessage(String sender, String text, String time, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: const AssetImage('assets/images/avatar/aldiyar.png'),
              onBackgroundImageError: (_, __) {
                // Placeholder если изображение не загрузилось
              },
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: !isMe ? Border.all(color: AppColors.inputBorder.withOpacity(0.3)) : null,
                boxShadow: !isMe ? [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.body1.copyWith(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: AppTextStyles.body3.copyWith(
                      color: isMe ? Colors.white.withOpacity(0.7) : AppColors.textSecondary,
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
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.inputBorder.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Напишите сообщение...',
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}