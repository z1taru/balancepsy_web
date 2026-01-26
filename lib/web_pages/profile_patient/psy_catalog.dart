// lib/web_pages/client/home_client.dart
import 'package:flutter/material.dart';
import '../services/psychologist_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  final PsychologistService _psychologistService = PsychologistService();
  
  List<Map<String, dynamic>> _psychologists = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPsychologists();
  }

  Future<void> _loadPsychologists() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final psychologists = await _psychologistService.getAllPsychologists();
      
      setState(() {
        _psychologists = psychologists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Найдите своего психолога', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                'Выберите специалиста из ${_psychologists.length} доступных',
                style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          IconButton(
            onPressed: _loadPsychologists,
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_psychologists.isEmpty) {
      return _buildEmptyState();
    }

    return _buildPsychologistsList();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Загрузка психологов...', style: AppTextStyles.body1),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Ошибка загрузки', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(_error ?? '', style: AppTextStyles.body1),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPsychologists,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Попробовать снова', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text('Психологи не найдены', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'Попробуйте обновить список или зайдите позже',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologistsList() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
      ),
      itemCount: _psychologists.length,
      itemBuilder: (context, index) {
        return _buildPsychologistCard(_psychologists[index]);
      },
    );
  }

  Widget _buildPsychologistCard(Map<String, dynamic> psychologist) {
    final bool isAvailable = psychologist['isAvailable'] ?? false;
    final String? avatarUrl = psychologist['avatarUrl'];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/psychologists/${psychologist['id']}',
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Аватар
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: avatarUrl != null
                  ? Image.network(
                      avatarUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                    )
                  : _buildAvatarPlaceholder(),
            ),

            // Информация
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            psychologist['fullName'] ?? 'Неизвестно',
                            style: AppTextStyles.h3.copyWith(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      psychologist['specialization'] ?? '',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '${psychologist['rating'] ?? 0.0}',
                          style: AppTextStyles.body2,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${psychologist['experienceYears'] ?? 0} лет опыта',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isAvailable
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  '/psychologists/${psychologist['id']}',
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: Text(
                          isAvailable ? 'Записаться' : 'Недоступен',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Center(
      child: Icon(
        Icons.person_outline,
        size: 80,
        color: AppColors.primary.withOpacity(0.3),
      ),
    );
  }
}