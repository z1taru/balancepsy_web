// lib/widgets/profile/profile_widgets.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// ========================================
// Виджет статистики профиля
// ========================================
class ProfileStatWidget extends StatelessWidget {
  final String label;
  final String value;

  const ProfileStatWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ========================================
// Виджет информационной строки профиля
// ========================================
class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isEditing;
  final TextEditingController? controller;
  final int maxLines;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isEditing = false,
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              isEditing && controller != null
                  ? _buildEditableField(controller!)
                  : Text(
                      value,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: maxLines > 1 ? 1.4 : 1.0,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: 'Введите $label',
          hintStyle: AppTextStyles.body1.copyWith(
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// ========================================
// Виджет выбора пола
// ========================================
class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildGenderOption('MALE', 'Мужской', Icons.male)),
        const SizedBox(width: 12),
        Expanded(child: _buildGenderOption('FEMALE', 'Женский', Icons.female)),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = selectedGender == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onGenderChanged(value),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.inputBorder.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================
// Виджет действия профиля
// ========================================
class ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;
  final bool isActive;

  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.inputBorder.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.1)
                      : (color ?? AppColors.primary).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: isActive
                      ? Border.all(color: AppColors.primary.withOpacity(0.3))
                      : null,
                ),
                child: Icon(
                  icon,
                  color:
                      color ??
                      (isActive ? AppColors.primary : AppColors.textSecondary),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color ?? AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color ?? AppColors.textSecondary.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================
// Виджет аватара с возможностью редактирования
// ========================================
class EditableAvatar extends StatelessWidget {
  final String? avatarUrl;
  final bool isEditing;
  final VoidCallback onEditTap;
  final double size;

  const EditableAvatar({
    super.key,
    this.avatarUrl,
    required this.isEditing,
    required this.onEditTap,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
              width: 3,
            ),
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),
        if (isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: size * 0.36,
                height: size * 0.36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: size * 0.16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Icon(Icons.person, size: size * 0.5, color: AppColors.primary),
    );
  }
}

// ========================================
// Виджет кнопок редактирования
// ========================================
class EditActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditActionButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.success.withOpacity(0.2)),
          ),
          child: IconButton(
            onPressed: onSave,
            icon: Icon(Icons.check, color: AppColors.success, size: 20),
            tooltip: 'Сохранить',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            tooltip: 'Отменить',
          ),
        ),
      ],
    );
  }
}

// ========================================
// Виджет кнопки редактирования
// ========================================
class EditButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
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
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
        tooltip: 'Редактировать профиль',
      ),
    );
  }
}
