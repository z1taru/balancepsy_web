// lib/web_pages/psycho/psycho_login.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../core/router/app_router.dart';
import '../../../services/user_provider.dart';

class PsychoLoginPage extends StatefulWidget {
  const PsychoLoginPage({super.key});

  @override
  State<PsychoLoginPage> createState() => _PsychoLoginPageState();
}

class _PsychoLoginPageState extends State<PsychoLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canLogin =>
      _emailController.text.contains('@') &&
      _passwordController.text.length >= 6;

  void _login() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Выполняем вход
    final success = await userProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      // Загружаем профиль
      await userProvider.loadProfile();

      if (mounted) {
        final role = userProvider.userRole;

        String redirectRoute;
        switch (role) {
          case 'PSYCHOLOGIST':
            redirectRoute = AppRouter.psychoDashboard;
            break;
          case 'CLIENT':
            redirectRoute = AppRouter.dashboard;
            break;
          case 'ADMIN':
            redirectRoute = AppRouter.psychoDashboard;
            break;
          default:
            redirectRoute = AppRouter.home;
        }

        Navigator.pushReplacementNamed(context, redirectRoute);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'Ошибка входа'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildLoginForm(isMobile: true),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: _buildLoginForm(isMobile: false),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(flex: 4, child: _buildIllustrationSide()),
      ],
    );
  }

  Widget _buildLoginForm({required bool isMobile}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 32),
          Row(
            children: [
              Icon(Icons.psychology, color: AppColors.primary, size: 32),
              const SizedBox(width: 12),
              Text('Вход для психологов', style: AppTextStyles.h1),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Войдите в личный кабинет специалиста',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildRememberAndForgot(),
          const SizedBox(height: 28),
          _buildLoginButton(),
          const SizedBox(height: 28),
          _buildBackToHome(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Text('Balance', style: AppTextStyles.logo.copyWith(fontSize: 28)),
        Text(
          'Psy',
          style: AppTextStyles.logo.copyWith(
            fontSize: 28,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          style: AppTextStyles.input,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'psychologist@email.com',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Пароль', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          style: AppTextStyles.input,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Введите пароль',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) =>
                  setState(() => _rememberMe = value ?? false),
              activeColor: AppColors.primary,
            ),
            Text('Запомнить меня', style: AppTextStyles.body2),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Забыли пароль?',
            style: AppTextStyles.body2.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CustomButton(
        text: 'Войти в кабинет',
        onPressed: _canLogin ? _login : null,
        isPrimary: true,
        isFullWidth: true,
      ),
    );
  }

  Widget _buildBackToHome() {
    return Center(
      child: TextButton.icon(
        onPressed: () => Navigator.pushNamed(context, AppRouter.home),
        icon: const Icon(Icons.arrow_back, size: 18),
        label: Text(
          'Вернуться на главную',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationSide() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withOpacity(0.3),
            AppColors.backgroundLight,
            AppColors.inputBackground,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology,
                size: 140,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Личный кабинет специалиста',
                style: AppTextStyles.h3.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Управляйте расписанием, общайтесь с клиентами и развивайте свою практику',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
