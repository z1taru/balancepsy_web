// lib/web_pages/profile_patient/blog_patient.dart

import 'package:flutter/material.dart';
import '../../../../../widgets/profile_patient/patient_bar.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../сore/router/app_router.dart';
import '../../../../../сore/services/profile_patient_service.dart';

class BlogPatientPage extends StatefulWidget {
  const BlogPatientPage({super.key});

  @override
  State<BlogPatientPage> createState() => _BlogPatientPageState();
}

class _BlogPatientPageState extends State<BlogPatientPage> {
  final ProfilePatientService _profileService = ProfilePatientService();

  String _selectedCategory = 'Все';
  bool _isLoading = true;
  String? _error;

  List<Map<String, dynamic>> _allArticles = [];
  List<Map<String, dynamic>> _filteredArticles = [];
  Map<String, dynamic>? _featuredArticle;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final articles = await _profileService.getArticles(limit: 50);

      setState(() {
        _allArticles = articles;
        _filteredArticles = articles;
        _featuredArticle = articles.isNotEmpty ? articles.first : null;
        _isLoading = false;
      });

      print('✅ Loaded ${_allArticles.length} articles');
    } catch (e) {
      print('❌ Error loading articles: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String category) {
    setState(() {
      _selectedCategory = category;

      if (category == 'Все') {
        _filteredArticles = _allArticles;
      } else {
        _filteredArticles = _allArticles.where((article) {
          final articleCategory = (article['category'] ?? '')
              .toString()
              .toLowerCase();
          return _getCategoryKey(category) == articleCategory;
        }).toList();
      }
    });
  }

  String _getCategoryKey(String displayName) {
    switch (displayName) {
      case 'Эмоции':
        return 'emotions';
      case 'Самопомощь':
        return 'self_help';
      case 'Отношения':
        return 'relationships';
      case 'Состояние покоя':
      case 'Стресс':
        return 'stress';
      default:
        return displayName.toLowerCase();
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
            child: PatientBar(currentRoute: AppRouter.patientArticles),
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _error != null
                ? _buildErrorState()
                : _buildContent(ctx),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Загрузка статей...', style: AppTextStyles.body1),
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
          Text('Ошибка загрузки статей', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(_error ?? '', style: AppTextStyles.body1),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadArticles,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Попробовать снова', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext ctx) {
    if (_allArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text('Статьи не найдены', style: AppTextStyles.h2),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        margin: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_featuredArticle != null) _buildFeaturedArticle(ctx),
            const SizedBox(height: 40),
            _buildCategoriesFilter(),
            const SizedBox(height: 32),
            _buildFilteredArticles(ctx),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedArticle(BuildContext ctx) {
    if (_featuredArticle == null) return const SizedBox.shrink();

    final title = _featuredArticle!['title'] ?? 'Без названия';
    final excerpt = _featuredArticle!['excerpt'] ?? '';
    final category = _featuredArticle!['category'] ?? 'other';
    final readTime = _featuredArticle!['readTime']?.toString() ?? '5';
    final thumbnailUrl = _featuredArticle!['thumbnailUrl'];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 400,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: _getCategoryColor(category).withOpacity(0.1),
            ),
            child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.article,
                          size: 80,
                          color: _getCategoryColor(category).withOpacity(0.3),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.article,
                      size: 80,
                      color: _getCategoryColor(category).withOpacity(0.3),
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getCategoryText(category),
                      style: AppTextStyles.body3.copyWith(
                        color: _getCategoryColor(category),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    excerpt,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$readTime мин чтения',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _openArticle(ctx, _featuredArticle!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Читать статью',
                      style: AppTextStyles.button.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    final categories = [
      {'name': 'Все', 'count': _allArticles.length},
      {
        'name': 'Эмоции',
        'count': _allArticles.where((a) => a['category'] == 'emotions').length,
      },
      {
        'name': 'Самопомощь',
        'count': _allArticles.where((a) => a['category'] == 'self_help').length,
      },
      {
        'name': 'Отношения',
        'count': _allArticles
            .where((a) => a['category'] == 'relationships')
            .length,
      },
      {
        'name': 'Стресс',
        'count': _allArticles.where((a) => a['category'] == 'stress').length,
      },
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = _selectedCategory == cat['name'];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _applyFilter(cat['name'] as String),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cat['name'] as String,
                      style: AppTextStyles.body1.copyWith(
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (cat['count'] as int).toString(),
                        style: AppTextStyles.body3.copyWith(
                          color: isActive ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilteredArticles(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCategory == 'Все' ? 'Все статьи' : _selectedCategory,
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_filteredArticles.length} ${_getArticleWord(_filteredArticles.length)}',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_filteredArticles.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'Нет статей в этой категории',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.3,
            ),
            itemCount: _filteredArticles.length,
            itemBuilder: (_, i) => _buildArticleCard(ctx, _filteredArticles[i]),
          ),
      ],
    );
  }

  String _getArticleWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'статья';
    if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'статьи';
    }
    return 'статей';
  }

  Widget _buildArticleCard(BuildContext ctx, Map<String, dynamic> article) {
    final title = article['title'] ?? 'Без названия';
    final category = article['category'] ?? 'other';
    final readTime = article['readTime']?.toString() ?? '5';
    final thumbnailUrl = article['thumbnailUrl'];

    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openArticle(ctx, article),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: _getCategoryColor(category).withOpacity(0.1),
                ),
                child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          thumbnailUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.article,
                              size: 40,
                              color: _getCategoryColor(
                                category,
                              ).withOpacity(0.3),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.article,
                          size: 40,
                          color: _getCategoryColor(category).withOpacity(0.3),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCategoryText(category),
                        style: AppTextStyles.body3.copyWith(
                          color: _getCategoryColor(category),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$readTime мин',
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openArticle(BuildContext ctx, Map<String, dynamic> article) {
    final slug = article['slug'];
    if (slug != null) {
      AppRouter.navigateTo(ctx, '/articles/$slug');
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'emotions':
        return const Color(0xFF4A90E2);
      case 'self_help':
        return const Color(0xFF50E3C2);
      case 'relationships':
        return const Color(0xFFF5A623);
      case 'stress':
        return const Color(0xFFE56B6F);
      default:
        return AppColors.primary;
    }
  }

  String _getCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'emotions':
        return 'ЭМОЦИИ';
      case 'self_help':
        return 'САМОПОМОЩЬ';
      case 'relationships':
        return 'ОТНОШЕНИЯ';
      case 'stress':
        return 'СТРЕСС';
      default:
        return 'ДРУГОЕ';
    }
  }
}
