// lib/widgets/ai_chat/floating_ai_button.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class FloatingAiButton extends StatefulWidget {
  final VoidCallback onPressed;
  final int unreadCount;

  const FloatingAiButton({
    super.key,
    required this.onPressed,
    this.unreadCount = 0,
  });

  @override
  State<FloatingAiButton> createState() => _FloatingAiButtonState();
}

class _FloatingAiButtonState extends State<FloatingAiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Главная кнопка
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                customBorder: const CircleBorder(),
                child: const Center(
                  child: Icon(
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          // Badge с количеством непрочитанных
          if (widget.unreadCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  widget.unreadCount > 9 ? '9+' : '${widget.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
