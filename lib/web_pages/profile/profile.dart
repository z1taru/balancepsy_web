// lib/web_pages/profile/profile.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/page_wrapper.dart';
import '../services/user_provider.dart';
import '../../core/router/app_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      currentRoute: '/profile',
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Показываем загрузку только при первой загрузке
          if (userProvider.isLoading && userProvider.user == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Показываем ошибку если есть
          if (userProvider.error != null && userProvider.user == null) {
            return _buildErrorState(context, userProvider.error!);
          }

          // Проверяем авторизацию
          if (!userProvider.isAuthenticated) {
            return _buildUnauthorized(context);
          }

          // Показываем профиль
          return _buildProfileContent(userProvider);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withOpacity(0.1),
            AppColors.backgroundLight,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Ошибка загрузки профиля',
                style: AppTextStyles.h1.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _loadProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Повторить', style: AppTextStyles.button),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.login,
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Войти снова', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnauthorized(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withOpacity(0.1),
            AppColors.backgroundLight,
          ],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_off_outlined,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Войдите в аккаунт',
                style: AppTextStyles.h1.copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Для доступа к профилю необходимо авторизоваться',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text('Войти', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.register);
                },
                child: Text(
                  'Создать аккаунт',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProvider userProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withOpacity(0.1),
            AppColors.backgroundLight,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: EdgeInsets.all(isMobile ? 20 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(userProvider, isMobile),
                const SizedBox(height: 32),
                _buildProfileCard(userProvider, isMobile),
                const SizedBox(height: 24),
                _buildStatsSection(isMobile),
                const SizedBox(height: 24),
                _buildQuickActions(isMobile),
                const SizedBox(height: 24),
                _buildSettingsSection(isMobile, userProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserProvider userProvider, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Личный кабинет',
              style: isMobile ? AppTextStyles.h2 : AppTextStyles.h1,
            ),
            const SizedBox(height: 4),
            Text(
              'Привет, ${_getFirstName(userProvider.userName)}! 👋',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        if (!isMobile)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Активен',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProfileCard(UserProvider userProvider, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: isMobile ? 80 : 100,
                    height: isMobile ? 80 : 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: userProvider.userAvatar == null
                          ? LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryLight,
                              ],
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: userProvider.userAvatar != null
                        ? ClipOval(
                            child: Image.network(
                              userProvider.userAvatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildAvatarPlaceholder(
                                    userProvider,
                                    isMobile,
                                  ),
                            ),
                          )
                        : _buildAvatarPlaceholder(userProvider, isMobile),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.userName ?? 'Пользователь',
                      style: isMobile ? AppTextStyles.h3 : AppTextStyles.h2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProvider.userEmail ?? '',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRoleBadge(userProvider.userRole),
                  ],
                ),
              ),
              if (!isMobile)
                IconButton(
                  onPressed: () {
                    // TODO: Edit profile
                  },
                  icon: const Icon(Icons.edit_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          _buildInfoGrid(userProvider, isMobile),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(UserProvider userProvider, bool isMobile) {
    return Center(
      child: Text(
        _getInitials(userProvider.userName),
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 32 : 40,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String? role) {
    final roleText = _getRoleText(role);
    final roleColor = _getRoleColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: roleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: roleColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRoleIcon(role), size: 16, color: roleColor),
          const SizedBox(width: 6),
          Text(
            roleText,
            style: AppTextStyles.body2.copyWith(
              color: roleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(UserProvider userProvider, bool isMobile) {
    return isMobile
        ? Column(
            children: [
              _buildInfoItem(
                'Email',
                userProvider.userEmail ?? 'Не указан',
                Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                'Телефон',
                userProvider.userPhone ?? 'Не указан',
                Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                'Роль',
                _getRoleText(userProvider.userRole),
                Icons.person_outline,
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Email',
                  userProvider.userEmail ?? 'Не указан',
                  Icons.email_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Телефон',
                  userProvider.userPhone ?? 'Не указан',
                  Icons.phone_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'Роль',
                  _getRoleText(userProvider.userRole),
                  Icons.person_outline,
                ),
              ),
            ],
          );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: AppColors.primary),
              const SizedBox(width: 12),
              Text('Моя статистика', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    _buildStatCard(
                      'Всего сессий',
                      '0',
                      Icons.event_note,
                      AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Завершено',
                      '0',
                      Icons.check_circle,
                      AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Запланировано',
                      '0',
                      Icons.schedule,
                      AppColors.warning,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Прогресс',
                      '0%',
                      Icons.trending_up,
                      Color(0xFF9C27B0),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Всего сессий',
                        '0',
                        Icons.event_note,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Завершено',
                        '0',
                        Icons.check_circle,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Запланировано',
                        '0',
                        Icons.schedule,
                        AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Прогресс',
                        '0%',
                        Icons.trending_up,
                        Color(0xFF9C27B0),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value, style: AppTextStyles.h2.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, color: AppColors.primary),
              const SizedBox(width: 12),
              Text('Быстрые действия', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                'Записаться',
                Icons.calendar_today,
                AppColors.primary,
                () {
                  Navigator.pushNamed(context, AppRouter.psychologists);
                },
              ),
              _buildActionButton(
                'Мои записи',
                Icons.event_note,
                AppColors.success,
                () {},
              ),
              _buildActionButton(
                'Чаты',
                Icons.chat_bubble_outline,
                Color(0xFF00BCD4),
                () {},
              ),
              _buildActionButton(
                'Статьи',
                Icons.article,
                Color(0xFF9C27B0),
                () {
                  Navigator.pushNamed(context, AppRouter.blog);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(bool isMobile, UserProvider userProvider) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppColors.primary),
              const SizedBox(width: 12),
              Text('Настройки', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingItem(
            'Редактировать профиль',
            'Изменить имя, фото и другие данные',
            Icons.edit_outlined,
            () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            'Изменить пароль',
            'Обновить пароль для входа',
            Icons.lock_outline,
            () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            'Уведомления',
            'Настроить уведомления',
            Icons.notifications_outlined,
            () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            'Конфиденциальность',
            'Управление данными и приватностью',
            Icons.privacy_tip_outlined,
            () {},
          ),
          const Divider(height: 32),
          _buildSettingItem(
            'Выйти',
            'Выход из аккаунта',
            Icons.logout,
            () async {
              await userProvider.performLogout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.home,
                  (route) => false,
                );
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isDestructive ? AppColors.error : AppColors.primary)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 24,
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
                      color: isDestructive
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
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
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  String _getFirstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'Пользователь';
    return fullName.split(' ').first;
  }

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'U';
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName[0].toUpperCase();
  }

  String _getRoleText(String? role) {
    switch (role) {
      case 'CLIENT':
        return 'Клиент';
      case 'PSYCHOLOGIST':
        return 'Психолог';
      case 'ADMIN':
        return 'Администратор';
      default:
        return 'Пользователь';
    }
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'CLIENT':
        return AppColors.primary;
      case 'PSYCHOLOGIST':
        return AppColors.success;
      case 'ADMIN':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getRoleIcon(String? role) {
    switch (role) {
      case 'CLIENT':
        return Icons.person;
      case 'PSYCHOLOGIST':
        return Icons.psychology;
      case 'ADMIN':
        return Icons.admin_panel_settings;
      default:
        return Icons.person_outline;
    }
  }
}
