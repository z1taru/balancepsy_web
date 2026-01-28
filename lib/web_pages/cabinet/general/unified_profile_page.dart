// lib/web_pages/cabinet/unified_profile_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/unified_sidebar.dart';
import '../../../widgets/profile_patient/profile_widgets.dart';
import '../../../сore/services/profile_api_service.dart';
import '../../../web_pages/services/user_provider.dart';
import '../../../сore/router/app_router.dart';

/// Унифицированная страница профиля для клиента и психолога
/// Автоматически адаптируется под роль пользователя
class UnifiedProfilePage extends StatefulWidget {
  const UnifiedProfilePage({super.key});

  @override
  State<UnifiedProfilePage> createState() => _UnifiedProfilePageState();
}

class _UnifiedProfilePageState extends State<UnifiedProfilePage> {
  final ProfileApiService _apiService = ProfileApiService();

  bool _isEditing = false;
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  // Controllers for editing
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedGender = 'MALE';
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      final profile = await _apiService.getProfile();
      if (profile != null) {
        setState(() {
          _profileData = profile;
          _nameController.text = profile['fullName'] ?? '';
          _phoneController.text = profile['phone'] ?? '';
          _selectedGender = profile['gender'] ?? 'MALE';
          
          // Для психолога
          if (profile['psychologistProfile'] != null) {
            _bioController.text = profile['psychologistProfile']['bio'] ?? '';
            _isAvailable = profile['psychologistProfile']['isAvailable'] ?? true;
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    try {
      final updated = await _apiService.updateProfile(
        fullName: _nameController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
      );

      if (updated != null) {
        // Обновляем UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadProfile();

        setState(() {
          _profileData = updated;
          _isEditing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Профиль успешно обновлен'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось обновить профиль'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleAvailability() async {
    final newAvailability = !_isAvailable;
    final success = await _apiService.updateAvailability(newAvailability);

    if (success) {
      setState(() => _isAvailable = newAvailability);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newAvailability
                  ? 'Вы теперь доступны для записи'
                  : 'Вы недоступны для записи',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          UnifiedSidebar(currentRoute: AppRouter.profile),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        final isPsychologist =
                            userProvider.userRole == 'PSYCHOLOGIST';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 32),
                            _buildProfileCard(isPsychologist),
                            const SizedBox(height: 24),
                            if (isPsychologist) ...[
                              _buildPsychologistStatsSection(),
                              const SizedBox(height: 24),
                              _buildAvailabilitySection(),
                              const SizedBox(height: 24),
                            ],
                            _buildPersonalInfoSection(isPsychologist),
                            const SizedBox(height: 24),
                            _buildActionsSection(),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Мой профиль', style: AppTextStyles.h1.copyWith(fontSize: 28)),
        if (!_isEditing)
          ElevatedButton.icon(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit, size: 20),
            label: const Text('Редактировать'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          )
        else
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() => _isEditing = false);
                  _loadProfile(); // Отменяем изменения
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Отмена'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check, size: 20),
                label: const Text('Сохранить'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildProfileCard(bool isPsychologist) {
    final avatarUrl = _profileData?['avatarUrl'];
    final fullName = _profileData?['fullName'] ?? 'Пользователь';
    final role = isPsychologist ? 'Психолог BalancePsy' : 'Клиент BalancePsy';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          EditableAvatar(
            avatarUrl: avatarUrl,
            isEditing: _isEditing,
            onEditTap: _handleAvatarUpload,
            size: 100,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: AppTextStyles.h2.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  role,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isPsychologist) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Специализация: ${_profileData?['psychologistProfile']?['specialization'] ?? 'Не указана'}',
                    style: AppTextStyles.body2,
                  ),
                  Text(
                    'Опыт работы: ${_profileData?['psychologistProfile']?['experienceYears'] ?? 0}+ лет',
                    style: AppTextStyles.body2,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologistStatsSection() {
    final psychProfile = _profileData?['psychologistProfile'];
    if (psychProfile == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Моя статистика', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          Row(
            children: [
              ProfileStatWidget(
                label: 'лет опыта',
                value: '${psychProfile['experienceYears'] ?? 0}+',
              ),
              const SizedBox(width: 40),
              ProfileStatWidget(
                label: 'сеансов',
                value: '${psychProfile['totalSessions'] ?? 0}',
              ),
              const SizedBox(width: 40),
              ProfileStatWidget(
                label: 'рейтинг',
                value: (psychProfile['rating'] ?? 0.0).toStringAsFixed(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (_isAvailable ? AppColors.success : AppColors.error)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isAvailable ? Icons.check_circle : Icons.cancel,
              color: _isAvailable ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Доступность для записи',
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  _isAvailable
                      ? 'Вы доступны для новых записей'
                      : 'Вы недоступны для новых записей',
                  style: AppTextStyles.body2
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            onChanged: (value) => _toggleAvailability(),
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(bool isPsychologist) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Личная информация', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          ProfileInfoRow(
            label: 'Имя',
            value: _profileData?['fullName'] ?? '',
            icon: Icons.person,
            isEditing: _isEditing,
            controller: _nameController,
          ),
          const SizedBox(height: 20),
          ProfileInfoRow(
            label: 'Email',
            value: _profileData?['email'] ?? '',
            icon: Icons.email,
          ),
          const SizedBox(height: 20),
          ProfileInfoRow(
            label: 'Телефон',
            value: _profileData?['phone'] ?? 'Не указан',
            icon: Icons.phone,
            isEditing: _isEditing,
            controller: _phoneController,
          ),
          if (_isEditing) ...[
            const SizedBox(height: 20),
            Text('Пол', style: AppTextStyles.body1),
            const SizedBox(height: 12),
            GenderSelector(
              selectedGender: _selectedGender,
              onGenderChanged: (gender) {
                setState(() => _selectedGender = gender);
              },
            ),
          ],
          if (isPsychologist) ...[
            const SizedBox(height: 20),
            ProfileInfoRow(
              label: 'О себе',
              value: _profileData?['psychologistProfile']?['bio'] ?? '',
              icon: Icons.description,
              isEditing: _isEditing,
              controller: _bioController,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Действия', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          ProfileActionTile(
            icon: Icons.lock_outline,
            title: 'Изменить пароль',
            subtitle: 'Обновите пароль для вашей безопасности',
            onTap: _showChangePasswordDialog,
          ),
          ProfileActionTile(
            icon: Icons.notifications_outlined,
            title: 'Уведомления',
            subtitle: 'Настройте уведомления',
            onTap: () {},
          ),
          ProfileActionTile(
            icon: Icons.help_outline,
            title: 'Помощь и поддержка',
            subtitle: 'Свяжитесь с нами',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.inputBorder.withOpacity(0.3)),
          const SizedBox(height: 16),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          await userProvider.performLogout();
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.home,
              (route) => false,
            );
          }
        },
        icon: const Icon(Icons.logout, size: 20),
        label: const Text('Выйти из аккаунта'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _handleAvatarUpload() {
    // TODO: Implement avatar upload
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Загрузить фото', style: AppTextStyles.h3),
        content: Text(
          'Функция загрузки фото будет доступна в следующей версии',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Изменить пароль', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Текущий пароль',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Новый пароль',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Подтвердите пароль',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}