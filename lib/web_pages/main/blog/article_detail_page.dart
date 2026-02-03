// lib/web_pages/main/blog/article_detail_page.dart

import 'package:flutter/material.dart';
import 'package:balance_psy/widgets/page_wrapper.dart';
import 'package:balance_psy/theme/app_text_styles.dart';
import 'package:balance_psy/theme/app_colors.dart';
import 'package:balance_psy/core/router/app_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:balance_psy/core/config/api_config.dart';

/// Универсальная страница для чтения статьи
class ArticleDetailPage extends StatefulWidget {
  final String slug;

  const ArticleDetailPage({super.key, required this.slug});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final ScrollController _scrollController = ScrollController();

  double _readingProgress = 0.0;
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _article;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
    _loadArticle();

    // Диагностика
    print('🔍 ArticleDetailPage initialized with slug: ${widget.slug}');
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      if (max > 0) {
        setState(() => _readingProgress = (current / max).clamp(0.0, 1.0));
      }
    }
  }

  Future<void> _loadArticle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url = ApiConfig.articleBySlug(widget.slug);
      print('📖 Loading article from: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headers)
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');
      print(
        '📡 Response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...',
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _article = data['data'];
            _isLoading = false;
          });
          print('✅ Article loaded: ${_article!['title']}');
        } else {
          throw Exception('Статья не найдена в ответе сервера');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Статья с slug "${widget.slug}" не найдена');
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading article: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return PageWrapper(
      currentRoute: AppRouter.blog,
      child: _isLoading
          ? _buildLoadingState()
          : _error != null
          ? _buildErrorState()
          : _buildArticleContent(isMobile),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Загрузка статьи...', style: AppTextStyles.body1),
          const SizedBox(height: 8),
          Text(
            'Slug: ${widget.slug}',
            style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 24),
            Text(
              'Ошибка загрузки статьи',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slug: ${widget.slug}',
                    style: AppTextStyles.body2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error ?? 'Неизвестная ошибка',
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: Text('Вернуться к статьям', style: AppTextStyles.button),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadArticle,
              child: Text('Попробовать снова'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleContent(bool isMobile) {
    if (_article == null) return const SizedBox.shrink();

    final title = _article!['title'] ?? 'Без названия';
    final content = _article!['content'] ?? '';
    final category = _article!['category'] ?? 'other';
    final readTime = _article!['readTime']?.toString() ?? '5';
    final createdAt = _article!['createdAt'] ?? '';
    final thumbnailUrl = _article!['thumbnailUrl'];

    return Column(
      children: [
        // Progress bar
        SizedBox(
          height: 4,
          child: LinearProgressIndicator(
            value: _readingProgress,
            backgroundColor: AppColors.inputBackground,
            valueColor: AlwaysStoppedAnimation(_getCategoryColor(category)),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60,
                vertical: isMobile ? 20 : 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.inputBorder),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Text(
                      'Назад',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Article header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getCategoryText(category),
                            style: AppTextStyles.body1.copyWith(
                              color: _getCategoryColor(category),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          title,
                          style: AppTextStyles.h1.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 28 : 36,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Meta info
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
                            const SizedBox(width: 24),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(createdAt),
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Thumbnail
                  if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        thumbnailUrl,
                        width: double.infinity,
                        height: isMobile ? 200 : 400,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: double.infinity,
                          height: isMobile ? 200 : 400,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.article,
                            size: 80,
                            color: _getCategoryColor(category).withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Article content
                  Container(
                    padding: EdgeInsets.all(isMobile ? 24 : 40),
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
                    child: _buildContent(content, category),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(String content, String category) {
    if (content.isEmpty) {
      return Text(
        'Содержимое статьи отсутствует',
        style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
      );
    }

    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        line = line.trim();

        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Text(
              line.substring(2),
              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700),
            ),
          );
        }

        if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              line.substring(3),
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
            ),
          );
        }

        if (line.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              line.substring(4),
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          );
        }

        if (line.startsWith('- ') || line.startsWith('* ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, right: 10),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: AppTextStyles.body1.copyWith(height: 1.6),
                  ),
                ),
              ],
            ),
          );
        }

        if (line.startsWith('> ')) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.05),
              border: Border(
                left: BorderSide(color: _getCategoryColor(category), width: 4),
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text(
              line.substring(2),
              style: AppTextStyles.body1.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          );
        }

        if (line.isEmpty) {
          return const SizedBox(height: 12);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(line, style: AppTextStyles.body1.copyWith(height: 1.6)),
        );
      }).toList(),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'января',
        'февраля',
        'марта',
        'апреля',
        'мая',
        'июня',
        'июля',
        'августа',
        'сентября',
        'октября',
        'ноября',
        'декабря',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
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
      case 'meditation':
        return const Color(0xFF9B59B6);
      case 'popular':
        return const Color(0xFF3498DB);
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
      case 'meditation':
        return 'МЕДИТАЦИЯ';
      case 'popular':
        return 'ПОПУЛЯРНОЕ';
      default:
        return 'ДРУГОЕ';
    }
  }
}
