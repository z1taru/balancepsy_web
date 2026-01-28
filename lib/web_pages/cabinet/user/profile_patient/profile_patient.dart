// lib/web_pages/profile_patient/profile_patient.dart

import 'package:flutter/material.dart';
import '../../../../widgets/profile_patient/patient_bar.dart';
import '../../../../widgets/profile_patient/profile_widgets.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../сore/router/app_router.dart';
import '../../../../сore/services/profile_patient_service.dart';
import '../../../../сore/services/auth_api_service.dart';

class ProfilePatientPage extends StatefulWidget {
  const ProfilePatientPage({super.key});

  @override
  State<ProfilePatientPage> createState() => _ProfilePatientPageState();
}

class _ProfilePatientPageState extends State<ProfilePatientPage> {
  final ProfilePatientService _profileService = ProfilePatientService();
  final AuthApiService _authService = AuthApiService();

  bool _isEditing = false;
  bool _isLoading = true;
  String? _error;

  // Данные профиля
  UserProfile? _userProfile;
  UserStatistics? _userStatistics;

  // Контроллеры для редактирования
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _therapyGoalsController = TextEditingController();

  String _selectedGender = 'MALE';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // ========================================
  // Загрузка данных профиля
  // ========================================
  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Загружаем профиль и статистику параллельно
      final results = await Future.wait([
        _profileService.getCurrentProfile(),
        _profileService.getUserStatistics(),
      ]);

      final profileData = results[0];
      final statisticsData = results[1];

      setState(() {
        _userProfile = UserProfile.fromJson(profileData['data'] ?? profileData);
        _userStatistics = UserStatistics.fromJson(
          statisticsData['data'] ?? statisticsData,
        );
        _isLoading = false;

        // Инициализируем контроллеры
        _initializeControllers();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _initializeControllers() {
    if (_userProfile == null) return;

    _nameController.text = _userProfile!.fullName;
    _phoneController.text = _userProfile!.phone ?? '';
    _birthDateController.text = _userProfile!.getFormattedBirthDate();
    _therapyGoalsController.text = _userProfile!.registrationGoal ?? '';
    _selectedGender = _userProfile!.gender ?? 'MALE';
  }

  // ========================================
  // Сохранение изменений
  // ========================================
  Future<void> _saveChanges() async {
    if (_userProfile == null) return;

    try {
      setState(() => _isLoading = true);

      await _profileService.updateProfile(
        fullName: _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        gender: _selectedGender,
        registrationGoal: _therapyGoalsController.text.isEmpty
            ? null
            : _therapyGoalsController.text,
      );

      // Перезагружаем данные
      await _loadProfileData();

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      _showSuccessSnackbar('Данные успешно сохранены');
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Ошибка сохранения: $e');
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _initializeControllers();
    });
  }

  // ========================================
  // Смена аватара
  // ========================================
  Future<void> _changeAvatar() async {
    _showComingSoon(context, 'Смена аватара');
    // TODO: Реализовать выбор и загрузку изображения
    // final picker = ImagePicker();
    // final image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   await _profileService.uploadAvatar(File(image.path));
    //   await _loadProfileData();
    // }
  }

  // ========================================
  // Выход из аккаунта
  // ========================================
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выход', style: AppTextStyles.h2),
        content: Text(
          'Вы уверены, что хотите выйти?',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Отмена', style: AppTextStyles.body1),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Выйти', style: AppTextStyles.button),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        AppRouter.navigateAndRemoveUntil(context, AppRouter.home);
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280,
            child: PatientBar(currentRoute: AppRouter.profile),
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _error != null
                ? _buildErrorState()
                : _buildProfileContent(ctx),
          ),
        ],
      ),
    );
  }

  // ========================================
  // Состояние загрузки
  // ========================================
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Загрузка профиля...', style: AppTextStyles.body1),
        ],
      ),
    );
  }

  // ========================================
  // Состояние ошибки
  // ========================================
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Ошибка загрузки профиля', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(_error ?? '', style: AppTextStyles.body1),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProfileData,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Попробовать снова', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  // ========================================
  // Основной контент
  // ========================================
  Widget _buildProfileContent(BuildContext ctx) {
    if (_userProfile == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        margin: const EdgeInsets.all(40),
        child: Column(
          children: [
            _buildProfileHeader(ctx),
            const SizedBox(height: 32),
            _buildProfileInfo(),
            const SizedBox(height: 32),
            _buildProfileActions(ctx),
          ],
        ),
      ),
    );
  }

  // ========================================
  // Заголовок профиля
  // ========================================
  Widget _buildProfileHeader(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Аватар
          EditableAvatar(
            avatarUrl: _userProfile!.avatarUrl,
            isEditing: _isEditing,
            onEditTap: _changeAvatar,
          ),

          const SizedBox(width: 28),

          // Информация о пользователе
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isEditing) ...[
                  Text(
                    _userProfile!.fullName,
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _userProfile!.email,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ] else ...[
                  _buildEditableHeaderField(_nameController, 'Имя'),
                  const SizedBox(height: 6),
                  Text(
                    _userProfile!.email,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Статистика
                if (_userStatistics != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProfileStatWidget(
                          label: 'Сессии',
                          value: _userStatistics!.completedSessions.toString(),
                        ),
                        ProfileStatWidget(
                          label: 'Статьи',
                          value: _userStatistics!.articlesRead.toString(),
                        ),
                        ProfileStatWidget(
                          label: 'Недели',
                          value: _userStatistics!.getWeeksActive(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Кнопки действий
          if (!_isEditing)
            EditButton(onPressed: _startEditing)
          else
            EditActionButtons(onSave: _saveChanges, onCancel: _cancelEditing),
        ],
      ),
    );
  }

  Widget _buildEditableHeaderField(
    TextEditingController controller,
    String hint,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.h1.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.h1.copyWith(
            fontSize: 32,
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          isDense: true,
        ),
      ),
    );
  }

  // ========================================
  // Личная информация
  // ========================================
  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Личная информация',
                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
              ),
              if (_isEditing)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Режим редактирования',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 28),

          ProfileInfoRow(
            label: 'Телефон',
            value: _userProfile!.phone ?? 'Не указан',
            icon: Icons.phone_outlined,
            isEditing: _isEditing,
            controller: _phoneController,
          ),

          const SizedBox(height: 20),

          ProfileInfoRow(
            label: 'Дата рождения',
            value: _userProfile!.getFormattedBirthDate(),
            icon: Icons.calendar_today_outlined,
            isEditing: false, // Дату рождения не редактируем
          ),

          const SizedBox(height: 20),

          // Пол
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Пол',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _isEditing
                        ? GenderSelector(
                            selectedGender: _selectedGender,
                            onGenderChanged: (gender) {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                          )
                        : Text(
                            _userProfile!.getLocalizedGender(),
                            style: AppTextStyles.body1.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ProfileInfoRow(
            label: 'Цели терапии',
            value: _userProfile!.registrationGoal ?? 'Не указаны',
            icon: Icons.flag_outlined,
            isEditing: _isEditing,
            controller: _therapyGoalsController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ========================================
  // Действия профиля
  // ========================================
  Widget _buildProfileActions(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.person_outline,
            title: 'Личные данные',
            subtitle: 'Управление основной информацией',
            onTap: _startEditing,
            isActive: _isEditing,
          ),
          ProfileActionTile(
            icon: Icons.event_available_outlined,
            title: 'Мои сессии',
            subtitle: 'История и расписание консультаций',
            onTap: () => _showComingSoon(ctx, 'Мои сессии'),
          ),
          ProfileActionTile(
            icon: Icons.credit_card_outlined,
            title: 'Оплата и подписка',
            subtitle: 'Способы оплаты и тарифы',
            onTap: () => _showComingSoon(ctx, 'Оплата и подписка'),
          ),
          ProfileActionTile(
            icon: Icons.settings_outlined,
            title: 'Настройки',
            subtitle: 'Конфиденциальность и уведомления',
            onTap: () => _showComingSoon(ctx, 'Настройки'),
          ),
          ProfileActionTile(
            icon: Icons.logout_outlined,
            title: 'Выйти',
            subtitle: 'Завершить текущий сеанс',
            color: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  // ========================================
  // Утилиты
  // ========================================
  void _showComingSoon(BuildContext ctx, String feature) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('$feature - скоро будет доступно'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _therapyGoalsController.dispose();
    super.dispose();
  }
}
