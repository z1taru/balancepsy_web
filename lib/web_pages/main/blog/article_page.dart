// lib/web_pages/main/blog/blog_page.dart

import 'package:flutter/material.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/web_layout.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/services/article_service.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final ArticleApiService _articleService = ArticleApiService();

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
      final response = await _articleService.getArticles(
        category: null, // Загружаем все
        page: 0,
        size: 50,
      );

      print('✅ Articles response: $response');

      if (response['success'] == true && response['data'] != null) {
        final articlesData = response['data'];

        List<Map<String, dynamic>> articles = [];
        if (articlesData is Map && articlesData['articles'] != null) {
          articles = List<Map<String, dynamic>>.from(articlesData['articles']);
        } else if (articlesData is List) {
          articles = List<Map<String, dynamic>>.from(articlesData);
        }

        setState(() {
          _allArticles = articles;
          _filteredArticles = articles;
          _featuredArticle = articles.isNotEmpty ? articles.first : null;
          _isLoading = false;
        });

        print('✅ Loaded ${_allArticles.length} articles');
      } else {
        throw Exception('Invalid response format');
      }
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
      case 'Стресс':
        return 'stress';
      case 'Медитация':
        return 'meditation';
      case 'Популярное':
        return 'popular';
      default:
        return displayName.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final isMobile = MediaQuery.of(ctx).size.width < 768;
    final isTablet =
        MediaQuery.of(ctx).size.width >= 768 &&
        MediaQuery.of(ctx).size.width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.blog,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(ctx, isMobile, isTablet),
          const SizedBox(height: 60),
          if (_isLoading)
            _buildLoadingState()
          else if (_error != null)
            _buildErrorState()
          else ...[
            if (_featuredArticle != null)
              _buildFeaturedArticleSection(ctx, isMobile, isTablet),
            const SizedBox(height: 40),
            _buildCategoriesSection(isMobile, isTablet),
            const SizedBox(height: 32),
            _buildArticlesGridSection(ctx, isMobile, isTablet),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext ctx, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.backgroundLight,
          ],
        ),
      ),
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 80,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroTag(),
                  const SizedBox(height: 24),
                  Text(
                    'Блог BalancePsy',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: isMobile ? 36 : 56,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Полезные статьи о ментальном здоровье, эмоциях, отношениях и саморазвитии от наших психологов. Читайте бесплатно.',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: isMobile ? 18 : 20,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        _buildFeatureBadge(
                          Icons.article_outlined,
                          '${_allArticles.length} статей',
                        ),
                        const SizedBox(width: 20),
                        _buildFeatureBadge(Icons.timer_outlined, '5-15 мин'),
                        const SizedBox(width: 20),
                        _buildFeatureBadge(
                          Icons.verified_user_outlined,
                          'Эксперты',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 60),
              Expanded(
                flex: 5,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu_book_outlined,
                      size: 160,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeroTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'База знаний',
        style: AppTextStyles.body2.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.body1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: WebLayout.content(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text('Загрузка статей...', style: AppTextStyles.body1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: WebLayout.content(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Попробовать снова', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedArticleSection(
    BuildContext ctx,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: _buildFeaturedArticle(ctx, isMobile),
      ),
    );
  }

  Widget _buildFeaturedArticle(BuildContext ctx, bool isMobile) {
    if (_featuredArticle == null) return const SizedBox.shrink();

    final title = _featuredArticle!['title'] ?? 'Без названия';
    final excerpt = _featuredArticle!['excerpt'] ?? '';
    final category = _featuredArticle!['category'] ?? 'other';
    final readTime = _featuredArticle!['readTime']?.toString() ?? '5';
    final thumbnailUrl = _featuredArticle!['thumbnailUrl'];

    if (isMobile) {
      return Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: _getCategoryColor(category).withOpacity(0.1),
              image: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(thumbnailUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: thumbnailUrl == null || thumbnailUrl.isEmpty
                ? Center(
                    child: Icon(
                      Icons.article,
                      size: 80,
                      color: _getCategoryColor(category).withOpacity(0.3),
                    ),
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
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
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: CustomButton(
                    text: 'Читать статью',
                    onPressed: () => _openArticle(ctx, _featuredArticle!),
                    isPrimary: true,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

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
            height: 320,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: _getCategoryColor(category).withOpacity(0.1),
              image: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(thumbnailUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: thumbnailUrl == null || thumbnailUrl.isEmpty
                ? Center(
                    child: Icon(
                      Icons.article,
                      size: 80,
                      color: _getCategoryColor(category).withOpacity(0.3),
                    ),
                  )
                : null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
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
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: AppTextStyles.h1.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    excerpt,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$readTime мин чтения',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: CustomButton(
                      text: 'Читать статью',
                      onPressed: () => _openArticle(ctx, _featuredArticle!),
                      isPrimary: true,
                      isFullWidth: true,
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

  Widget _buildCategoriesSection(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundLight,
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: _buildCategoriesFilter(isMobile),
      ),
    );
  }

  Widget _buildCategoriesFilter(bool isMobile) {
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

    if (isMobile) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((cat) {
          final isActive = _selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () => _applyFilter(cat['name'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.inputBorder.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
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
                      vertical: 4,
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
          );
        }).toList(),
      );
    }

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
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.inputBorder.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cat['name'] as String,
                      style: AppTextStyles.body1.copyWith(
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (cat['count'] as int).toString(),
                        style: AppTextStyles.body2.copyWith(
                          color: isActive ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
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

  Widget _buildArticlesGridSection(
    BuildContext ctx,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        ),
        child: _buildFilteredArticles(ctx, isMobile),
      ),
    );
  }

  Widget _buildFilteredArticles(BuildContext ctx, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCategory == 'Все' ? 'Все статьи' : _selectedCategory,
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 28 : 36,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        const SizedBox(height: 24),
        if (_filteredArticles.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text('Нет статей в этой категории', style: AppTextStyles.h3),
                ],
              ),
            ),
          )
        else if (isMobile)
          Column(
            children: _filteredArticles.map((article) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildArticleCard(ctx, article, isMobile: true),
              );
            }).toList(),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.3,
            ),
            itemCount: _filteredArticles.length,
            itemBuilder: (_, i) {
              return _buildArticleCard(
                ctx,
                _filteredArticles[i],
                isMobile: false,
              );
            },
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

  Widget _buildArticleCard(
    BuildContext ctx,
    Map<String, dynamic> article, {
    required bool isMobile,
  }) {
    final title = article['title'] ?? 'Без названия';
    final category = article['category'] ?? 'other';
    final readTime = article['readTime']?.toString() ?? '5';
    final thumbnailUrl = article['thumbnailUrl'];

    return Container(
      height: isMobile ? null : 280,
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
                height: isMobile ? 160 : 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: _getCategoryColor(category).withOpacity(0.1),
                  image: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(thumbnailUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: thumbnailUrl == null || thumbnailUrl.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.article,
                          size: 40,
                          color: _getCategoryColor(category).withOpacity(0.3),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
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
    if (slug != null && slug.toString().isNotEmpty) {
      Navigator.pushNamed(ctx, '/blog/$slug');
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
