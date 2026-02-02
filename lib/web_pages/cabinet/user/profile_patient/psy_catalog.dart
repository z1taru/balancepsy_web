// lib/web_pages/profile_patient/psy_catalog.dart
import 'package:balance_psy/widgets/unified_sidebar.dart';
import 'package:flutter/material.dart';
import '../../../services/psychologist_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class PsyCatalogPage extends StatefulWidget {
  const PsyCatalogPage({super.key});

  @override
  State<PsyCatalogPage> createState() => _PsyCatalogPageState();
}

class _PsyCatalogPageState extends State<PsyCatalogPage> {
  final PsychologistService _psychologistService = PsychologistService();

  List<Map<String, dynamic>> _psychologists = [];
  List<Map<String, dynamic>> _filteredPsychologists = [];
  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _selectedSpecialization = 'Все';
  bool _showOnlyAvailable = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPsychologists();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
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
        _filteredPsychologists = psychologists;
        _isLoading = false;
      });

      print('✅ Loaded ${_psychologists.length} psychologist(s)');
    } catch (e) {
      print('❌ Error loading psychologists: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredPsychologists = _psychologists.where((psychologist) {
        // Фильтр по поиску
        if (_searchQuery.isNotEmpty) {
          final name = (psychologist['fullName'] ?? '')
              .toString()
              .toLowerCase();
          final specialization = (psychologist['specialization'] ?? '')
              .toString()
              .toLowerCase();
          final query = _searchQuery.toLowerCase();

          if (!name.contains(query) && !specialization.contains(query)) {
            return false;
          }
        }

        // Фильтр по специализации
        if (_selectedSpecialization != 'Все') {
          final specialization = (psychologist['specialization'] ?? '')
              .toString();
          if (!specialization.contains(_selectedSpecialization)) {
            return false;
          }
        }

        // Фильтр по доступности
        if (_showOnlyAvailable) {
          final isAvailable = psychologist['isAvailable'] ?? true;
          if (!isAvailable) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280,
            child: UnifiedSidebar(currentRoute: AppRouter.contactsPatient),
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Найдите своего психолога', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Выберите специалиста из ${_psychologists.length} доступных',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _loadPsychologists,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Обновить',
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_filteredPsychologists.length} из ${_psychologists.length}',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Поиск и фильтры
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.inputBorder.withOpacity(0.3),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск по имени или специализации...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.inputBorder.withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSpecialization,
                      isExpanded: true,
                      items:
                          [
                            'Все',
                            'КПТ',
                            'Семейная терапия',
                            'Самооценка',
                            'Стресс',
                            'Детская психология',
                          ].map((spec) {
                            return DropdownMenuItem(
                              value: spec,
                              child: Text(spec, style: AppTextStyles.body1),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSpecialization = value ?? 'Все';
                          _applyFilters();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: _showOnlyAvailable
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _showOnlyAvailable
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showOnlyAvailable = !_showOnlyAvailable;
                        _applyFilters();
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _showOnlyAvailable
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: _showOnlyAvailable
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Только доступные',
                            style: AppTextStyles.body1.copyWith(
                              color: _showOnlyAvailable
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

    if (_filteredPsychologists.isEmpty) {
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
            'Попробуйте изменить фильтры или критерии поиска',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedSpecialization = 'Все';
                _showOnlyAvailable = false;
                _applyFilters();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Сбросить фильтры', style: AppTextStyles.button),
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
      itemCount: _filteredPsychologists.length,
      itemBuilder: (context, index) {
        return _buildPsychologistCard(_filteredPsychologists[index]);
      },
    );
  }

  Widget _buildPsychologistCard(Map<String, dynamic> psychologist) {
    final bool isAvailable = psychologist['isAvailable'] ?? true;
    final String? avatarUrl = psychologist['avatarUrl'];
    final String fullName = psychologist['fullName'] ?? 'Неизвестно';
    final String specialization = psychologist['specialization'] ?? '';
    final double rating = (psychologist['rating'] ?? 0.0).toDouble();
    final int experienceYears = psychologist['experienceYears'] ?? 0;
    final int totalSessions = psychologist['totalSessions'] ?? 0;
    final int hourlyRate = ((psychologist['hourlyRate'] ?? 0) as num).toInt();
    final int id = psychologist['id'] ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/psychologists/$id');
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Аватар
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: avatarUrl != null && avatarUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            avatarUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildAvatarPlaceholder(),
                          ),
                        )
                      : _buildAvatarPlaceholder(),
                ),
                // Бейдж доступности
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isAvailable ? 'Доступен' : 'Занят',
                          style: AppTextStyles.body3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Информация
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      specialization,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.body2,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.work_history,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$experienceYears лет',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$totalSessions сессий',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Divider(color: AppColors.inputBorder.withOpacity(0.3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'от $hourlyRate ₸',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '/ час',
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isAvailable
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  '/psychologists/$id',
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isAvailable ? 'Записаться' : 'Недоступно',
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
