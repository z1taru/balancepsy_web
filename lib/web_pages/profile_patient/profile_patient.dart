// ════════════════════════════════════════════════════════════════════════
// lib/web_pages/profile_patient/profile_patient.dart
// ════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/profile_patient/patient_bar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../сore/router/app_router.dart';

class ProfilePatientPage extends StatefulWidget {
  const ProfilePatientPage({super.key});

  @override
  State<ProfilePatientPage> createState() => _ProfilePatientPageState();
}

class _ProfilePatientPageState extends State<ProfilePatientPage> {
  bool _isEditing = false;
  
  // Данные профиля
  String _name = 'Альдияр';
  String _email = 'aldiyar@example.com';
  String _phone = '+7 (777) 123-45-67';
  String _birthDate = '15 марта 1990';
  String _gender = 'Мужской';
  String _therapyGoals = 'Снижение тревожности, работа со стрессом';
  
  // Контроллеры для редактирования
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _therapyGoalsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = _name;
    _emailController.text = _email;
    _phoneController.text = _phone;
    _birthDateController.text = _birthDate;
    _therapyGoalsController.text = _therapyGoals;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveChanges() {
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      _phone = _phoneController.text;
      _birthDate = _birthDateController.text;
      _therapyGoals = _therapyGoalsController.text;
      _isEditing = false;
    });
    
    _showSuccessSnackbar('Данные успешно сохранены');
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _initializeControllers();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фиксированный сайдбар, который не скролится
          Container(
            width: 280,
            child: PatientBar(currentRoute: AppRouter.profile),
          ),
          // Основной контент с возможностью скролла
          Expanded(
            child: SingleChildScrollView(
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
            ),
          ),
        ],
      ),
    );
  }

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
          // Аватар с возможностью редактирования
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar/aldiyar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeAvatar,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: 28),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isEditing) ...[
                  Text(_name, 
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _email,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ] else ...[
                  _buildEditableField(
                    controller: _nameController,
                    hintText: 'Введите имя',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildEditableField(
                    controller: _emailController,
                    hintText: 'Введите email',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Статистика
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      _buildProfileStat('Сессии', '12'),
                      _buildProfileStat('Статьи', '8'),
                      _buildProfileStat('Недели', '6'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Кнопки действий
          if (!_isEditing)
            _buildEditButton()
          else
            _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
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
        onPressed: _startEditing,
        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
        tooltip: 'Редактировать профиль',
      ),
    );
  }

  Widget _buildActionButtons() {
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
            onPressed: _saveChanges,
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
            onPressed: _cancelEditing,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            tooltip: 'Отменить',
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hintText,
    required TextStyle style,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: style,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: style.copyWith(color: AppColors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
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
              Text('Личная информация', 
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_isEditing)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          
          _buildInfoRow('Телефон', _phone, _phoneController, Icons.phone_outlined),
          const SizedBox(height: 20),
          _buildInfoRow('Дата рождения', _birthDate, _birthDateController, Icons.calendar_today_outlined),
          const SizedBox(height: 20),
          _buildGenderRow(),
          const SizedBox(height: 20),
          _buildTherapyGoalsRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, TextEditingController controller, IconData icon) {
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
              _isEditing
                  ? _buildEditableInfoField(controller, label)
                  : Text(
                      value,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableInfoField(TextEditingController controller, String label) {
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
        maxLines: label == 'Цели терапии' ? 3 : 1,
        decoration: InputDecoration(
          hintText: 'Введите $label',
          hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildGenderRow() {
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
          child: const Icon(Icons.person_outline, size: 20, color: AppColors.primary),
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
                  ? _buildGenderSelector()
                  : Text(
                      _gender,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(child: _buildGenderOption('Мужской', Icons.male)),
        const SizedBox(width: 12),
        Expanded(child: _buildGenderOption('Женский', Icons.female)),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _gender == gender;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _gender = gender;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.inputBorder.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
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
                gender,
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

  Widget _buildTherapyGoalsRow() {
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
          child: const Icon(Icons.flag_outlined, size: 20, color: AppColors.primary),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Цели терапии',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _isEditing
                  ? _buildEditableInfoField(_therapyGoalsController, 'Цели терапии')
                  : Text(
                      _therapyGoals,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext ctx) {
    final actions = [
      _ProfileAction(
        icon: Icons.person_outline,
        title: 'Личные данные',
        subtitle: 'Управление основной информацией',
        onTap: _startEditing,
        isActive: _isEditing,
      ),
      _ProfileAction(
        icon: Icons.event_available_outlined,
        title: 'Мои сессии',
        subtitle: 'История и расписание консультаций',
        onTap: () => _showComingSoon(ctx, 'Мои сессии'),
      ),
      _ProfileAction(
        icon: Icons.credit_card_outlined,
        title: 'Оплата и подписка',
        subtitle: 'Способы оплаты и тарифы',
        onTap: () => _showComingSoon(ctx, 'Оплата и подписка'),
      ),
      _ProfileAction(
        icon: Icons.settings_outlined,
        title: 'Настройки',
        subtitle: 'Конфиденциальность и уведомления',
        onTap: () => _showComingSoon(ctx, 'Настройки'),
      ),
      _ProfileAction(
        icon: Icons.logout_outlined,
        title: 'Выйти',
        subtitle: 'Завершить текущий сеанс',
        color: Colors.red,
        onTap: () => _showComingSoon(ctx, 'Выход'),
      ),
    ];

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
        children: actions.map((action) => _buildProfileActionTile(action)).toList(),
      ),
    );
  }

  Widget _buildProfileActionTile(_ProfileAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
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
                  color: action.isActive 
                      ? AppColors.primary.withOpacity(0.1)
                      : (action.color ?? AppColors.primary).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: action.isActive 
                      ? Border.all(color: AppColors.primary.withOpacity(0.3))
                      : null,
                ),
                child: Icon(
                  action.icon,
                  color: action.color ?? (action.isActive ? AppColors.primary : AppColors.textSecondary),
                  size: 22,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: action.color ?? AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
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
                color: action.color ?? AppColors.textSecondary.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeAvatar() {
    _showComingSoon(context, 'Смена аватара');
  }

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _therapyGoalsController.dispose();
    super.dispose();
  }
}

class _ProfileAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;
  final bool isActive;

  _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
    this.isActive = false,
  });
}