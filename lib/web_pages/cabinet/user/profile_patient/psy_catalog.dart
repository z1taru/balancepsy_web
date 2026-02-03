// lib/web_pages/cabinet/user/profile_patient/psy_catalog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balance_psy/widgets/unified_sidebar.dart';
import '../../../../core/services/psychologist_service.dart';
import '../../../../providers/user_provider.dart';
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
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredPsychologists = _psychologists.where((p) {
        if (_searchQuery.isNotEmpty) {
          final name = (p['fullName'] ?? '').toString().toLowerCase();
          final spec = (p['specialization'] ?? '').toString().toLowerCase();
          final q = _searchQuery.toLowerCase();
          if (!name.contains(q) && !spec.contains(q)) return false;
        }
        if (_selectedSpecialization != 'Все') {
          if (!(p['specialization'] ?? '').toString().contains(
            _selectedSpecialization,
          ))
            return false;
        }
        // «Только доступные» — фильтр по онлайн-статусу, НЕ блокировка записи
        if (_showOnlyAvailable) {
          if (p['isAvailable'] != true) return false;
        }
        return true;
      }).toList();
    });
  }

  // ─── Navigation: кнопка записи ───────────────────────────────
  /// Логика:
  ///  1. Если не авторизован → навигация на login
  ///  2. Если роль PSYCHOLOGIST → снэкбар «нельзя записаться»
  ///  3. Иначе → /booking/:id  (доступность слотов проверяется НЕ здесь)
  void _handleBooking(BuildContext context, Map<String, dynamic> psychologist) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!userProvider.isAuthenticated) {
      Navigator.pushNamed(context, AppRouter.login);
      return;
    }

    if (userProvider.userRole == 'PSYCHOLOGIST') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Психологи не могут записываться'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final id = psychologist['id'] ?? 0;
    Navigator.pushNamed(
      context,
      '/booking/$id',
      arguments: {'name': psychologist['fullName'] ?? 'Психолог'},
    );
  }

  // ─── BUILD ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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

  // ─── Header: поиск + фильтры ──────────────────────────────────
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
          // Поиск + фильтры
          Row(
            children: [
              // Поиск
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
              // Специализация
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
                              ]
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s, style: AppTextStyles.body1),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() {
                        _selectedSpecialization = v ?? 'Все';
                        _applyFilters();
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Чекбокс «только доступные» — фильтр по онлайн-статусу
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
                    onTap: () => setState(() {
                      _showOnlyAvailable = !_showOnlyAvailable;
                      _applyFilters();
                    }),
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

  // ─── Body ─────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState();
    if (_error != null) return _buildErrorState();
    if (_filteredPsychologists.isEmpty) return _buildEmptyState();
    return _buildPsychologistsList();
  }

  Widget _buildLoadingState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: AppColors.primary),
        const SizedBox(height: 16),
        Text('Загрузка психологов...', style: AppTextStyles.body1),
      ],
    ),
  );

  Widget _buildErrorState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
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

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
        const SizedBox(height: 16),
        Text('Психологи не найдены', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text(
          'Попробуйте изменить фильтры',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => setState(() {
            _searchController.clear();
            _selectedSpecialization = 'Все';
            _showOnlyAvailable = false;
            _applyFilters();
          }),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text('Сбросить фильтры', style: AppTextStyles.button),
        ),
      ],
    ),
  );

  // ─── Grid карточек ────────────────────────────────────────────
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
      itemBuilder: (context, index) =>
          _buildPsychologistCard(_filteredPsychologists[index]),
    );
  }

  // ─── Карточка психолога ───────────────────────────────────────
  Widget _buildPsychologistCard(Map<String, dynamic> p) {
    final bool isAvailable =
        p['isAvailable'] ?? true; // онлайн-статус (индикатор только)
    final String? avatarUrl = p['avatarUrl'];
    final String fullName = p['fullName'] ?? 'Неизвестно';
    final String specialization = p['specialization'] ?? '';
    final double rating = (p['rating'] ?? 0.0).toDouble();
    final int experienceYears = p['experienceYears'] ?? 0;
    final int totalSessions = p['totalSessions'] ?? 0;
    final int hourlyRate = ((p['hourlyRate'] ?? 0) as num).toInt();
    final int id = p['id'] ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/psychologists/$id'),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Аватар + бейдж онлайн-статуса ──
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
                            errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                          ),
                        )
                      : _avatarPlaceholder(),
                ),
                // Бейдж: Доступен / Занят — только визуальный индикатор
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

            // ── Информация ──
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
                    // Рейтинг + опыт
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
                    // Количество сессий
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
                    // Цена
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

                    // ✅ ИСПРАВЛЕНИЕ: кнопка ВСЕГДА активна.
                    // «isAvailable» = онлайн-статус, не влияет на возможность записи.
                    // Доступность слотов проверяется на странице /booking/:id.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleBooking(context, p),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Записаться', style: AppTextStyles.button),
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

  Widget _avatarPlaceholder() => Center(
    child: Icon(
      Icons.person_outline,
      size: 80,
      color: AppColors.primary.withOpacity(0.3),
    ),
  );
}
