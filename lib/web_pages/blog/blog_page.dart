// lib/web_pages/blog/blog_page.dart

import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../сore/router/app_router.dart';
import '../../widgets/custom_button.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  String _selectedCategory = 'Все';

  @override
  @override
  Widget build(BuildContext ctx) {
    final isMobile = MediaQuery.of(ctx).size.width < 768;
    final isTablet = MediaQuery.of(ctx).size.width >= 768 && MediaQuery.of(ctx).size.width < 1024;
    final padding = EdgeInsets.symmetric(
      horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
    );
    
    return PageWrapper(
      currentRoute: AppRouter.blog,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(ctx, isMobile, isTablet),
          const SizedBox(height: 60),
          Padding(
            padding: padding,
            child: _buildFeaturedArticle(ctx, isMobile),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: padding,
            child: _buildCategoriesFilter(isMobile),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: padding,
            child: _buildFilteredArticles(ctx, isMobile),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 60 : 80,
      ),
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
                      _buildFeatureBadge(Icons.article_outlined, '50+ статей'),
                      const SizedBox(width: 20),
                      _buildFeatureBadge(Icons.timer_outlined, '5-15 мин'),
                      const SizedBox(width: 20),
                      _buildFeatureBadge(Icons.verified_user_outlined, 'Эксперты'),
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

  Widget _buildFeaturedArticle(BuildContext ctx, bool isMobile) {
    final featured = _getAllArticles().firstWhere((a) => a['featured'] == true);
    
    if (isMobile) {
      return Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage(featured['image'] as String),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (featured['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    featured['category'] as String,
                    style: AppTextStyles.body3.copyWith(
                      color: featured['color'] as Color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  featured['title'] as String,
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Text(
                  featured['preview'] as String,
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
                    Icon(Icons.access_time_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      featured['readTime'] as String,
                      style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      featured['date'] as String,
                      style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: CustomButton(
                    text: 'Читать статью',
                    onPressed: () => _openArticleReader(ctx, featured),
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
              image: DecorationImage(
                image: AssetImage(featured['image'] as String),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (featured['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      featured['category'] as String,
                      style: AppTextStyles.body3.copyWith(
                        color: featured['color'] as Color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    featured['title'] as String,
                    style: AppTextStyles.h1.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    featured['preview'] as String,
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
                      Icon(Icons.access_time_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        featured['readTime'] as String,
                        style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 24),
                      Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        featured['date'] as String,
                        style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    height: 48,
                    child: CustomButton(
                      text: 'Читать статью',
                      onPressed: () => _openArticleReader(ctx, featured),
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

  Widget _buildCategoriesFilter(bool isMobile) {
    final categories = [
      {'name': 'Все', 'count': 18},
      {'name': 'Эмоции', 'count': 5},
      {'name': 'Самопомощь', 'count': 4},
      {'name': 'Отношения', 'count': 3},
      {'name': 'Медитация', 'count': 3},
      {'name': 'Популярное', 'count': 3},
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((cat) {
          final isActive = _selectedCategory == cat['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['name'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.inputBorder.withOpacity(0.5),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              onTap: () => setState(() => _selectedCategory = cat['name'] as String),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.inputBorder.withOpacity(0.5),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  Widget _buildFilteredArticles(BuildContext ctx, bool isMobile) {
    final all = _getAllArticles();
    final filtered = _selectedCategory == 'Все'
        ? all
        : all.where((a) => a['category'] == _selectedCategory).toList();

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
                '${filtered.length} статьи',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (isMobile)
          Column(
            children: filtered.map((a) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildArticleCard(
                  ctx: ctx,
                  title: a['title'] as String,
                  category: a['category'] as String,
                  readTime: a['readTime'] as String,
                  date: a['date'] as String,
                  imagePath: a['image'] as String,
                  color: a['color'] as Color,
                  content: a['content'] as String,
                  isMobile: true,
                ),
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
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final a = filtered[i];
              return _buildArticleCard(
                ctx: ctx,
                title: a['title'] as String,
                category: a['category'] as String,
                readTime: a['readTime'] as String,
                date: a['date'] as String,
                imagePath: a['image'] as String,
                color: a['color'] as Color,
                content: a['content'] as String,
                isMobile: false,
              );
            },
          ),
      ],
    );
  }

  Widget _buildArticleCard({
    required BuildContext ctx,
    required String title,
    required String category,
    required String readTime,
    required String date,
    required String imagePath,
    required Color color,
    required String content,
    required bool isMobile,
  }) {
    if (isMobile) {
      return Container(
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
            onTap: () => _openArticleReader(ctx, {
              'title': title,
              'category': category,
              'readTime': readTime,
              'date': date,
              'image': imagePath,
              'color': color,
              'content': content,
            }),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: AppTextStyles.body3.copyWith(
                            color: color,
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
                          Icon(Icons.access_time_outlined,
                              size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            readTime,
                            style: AppTextStyles.body3.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Icon(Icons.calendar_today_outlined,
                              size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            date,
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

    return Container(
      height: 280,
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
          onTap: () => _openArticleReader(ctx, {
            'title': title,
            'category': category,
            'readTime': readTime,
            'date': date,
            'image': imagePath,
            'color': color,
            'content': content,
          }),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.body3.copyWith(
                          color: color,
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
                        Icon(Icons.access_time_outlined,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          readTime,
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.calendar_today_outlined,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          date,
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

  void _openArticleReader(BuildContext ctx, Map<String, dynamic> article) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => ArticleReaderPage(article: article),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllArticles() {
    return [
      {
        'title': 'Mindfulness: как практика осознанности меняет мозг',
        'category': 'Медитация',
        'readTime': '10 мин',
        'date': '15 ноября 2024',
        'image': 'assets/images/article/calm.png',
        'color': const Color(0xFFFF6B9D),
        'preview':
            'Регулярная практика осознанности перестраивает мозг, снижая стресс и улучшая фокус.',
        'content': '''
# Что такое mindfulness?

Mindfulness — это осознанное пребывание в настоящем моменте без оценки. Это не медитация в лотосе, а навык, который можно тренировать в любой момент: за едой, в транспорте, на встрече.

## Как это работает в мозге?

Нейробиологи из Гарварда провели МРТ-исследования и обнаружили:

- Увеличение серого вещества в гиппокампе — центре памяти и обучения
- Снижение активности миндалины — центра страха и тревоги
- Усиление связей в префронтальной коре — зоне самоконтроля

### Практика 5 минут в день

1. Сядьте удобно
2. Закройте глаза
3. Сфокусируйтесь на дыхании
4. Когда мысли уводят — мягко возвращайтесь

> Уже через 8 недель регулярной практики мозг начинает меняться физически.

### Польза для жизни

- Снижение кортизола на 30%
- Улучшение сна на 40%
- Рост эмпатии и эмоционального интеллекта

Попробуйте прямо сейчас — это бесплатно и доступно каждому.
        ''',
        'featured': true,
      },
      {
        'title': 'Как справляться с тревогой в повседневной жизни',
        'category': 'Эмоции',
        'readTime': '8 мин',
        'date': '12 ноя 2024',
        'image': 'assets/images/article/sad.png',
        'color': const Color(0xFF4A90E2),
        'preview':
            'Тревога — это не враг. Это сигнал. Учитесь его понимать и управлять.',
        'content': '''
# Тревога — это нормально

Каждый человек испытывает тревогу. Это защитный механизм, который помогал нашим предкам выживать. Проблема начинается, когда тревога становится хронической.

## Техника "Назови и отпусти"

1. Заметьте тревогу
2. Назови её: "Я чувствую тревогу в груди"
3. Спросите: "Это реальная угроза?"
4. Дайте телу 90 секунд — пик тревоги пройдёт

### Дыхание 4-7-8

- Вдох на 4 счёта
- Задержка на 7
- Выдох на 8

Повторите 4 раза. Это активирует парасимпатическую систему.

> Тревога не может длиться вечно. Она всегда проходит.

### Что делать дальше?

- Двигайтесь — 10 минут прогулки снижают тревогу на 25%
- Пишите — выгрузите мысли на бумагу
- Говорите — поделитесь с близким

Тревога — это не вы. Это временное состояние.
        ''',
        'featured': false,
      },
      {
        'title': 'Техники дыхания для релаксации',
        'category': 'Самопомощь',
        'readTime': '6 мин',
        'date': '10 ноя 2024',
        'image': 'assets/images/article/5min.png',
        'color': const Color(0xFF50E3C2),
        'preview':
            'Дыхание — самый быстрый способ успокоить нервную систему.',
        'content': '''
# Дыхание — ваш встроенный антистресс

Когда вы дышите глубоко, вы активируете блуждающий нерв, который замедляет сердцебиение и снижает давление.

## Техника "Коробочное дыхание"

1. Вдох — 4 секунды
2. Задержка — 4 секунды
3. Выдох — 4 секунды
4. Задержка — 4 секунды

Повторите 5 циклов.

### Когда использовать?

- Перед важной встречей
- После конфликта
- При бессоннице
- В пробке

> 3 минуты практики = 30 минут спокойствия.

### Бонус: дыхание "по квадрату"

Представьте квадрат:
- Вверх — вдох
- Вправо — задержка
- Вниз — выдох
- Влево — задержка

Это помогает детям и взрослым с СДВГ.

Дышите осознанно — живите спокойнее.
        ''',
        'featured': false,
      },
      {
        'title': 'Почему мы избегаем конфликтов',
        'category': 'Отношения',
        'readTime': '9 мин',
        'date': '8 ноя 2024',
        'image': 'assets/images/article/dontAgro.png',
        'color': const Color(0xFFF5A623),
        'preview':
            'Избегание конфликтов разрушает отношения. Учитесь говорить открыто.',
        'content': '''
# Конфликт — это не плохо

Конфликт — это столкновение потребностей. Избегание его приводит к накоплению обид и дистанции.

## Почему мы боимся?

- Страх быть отвергнутым
- Воспитание: "Хорошие девочки не спорят"
- Прошлый негативный опыт

### Как начать говорить?

1. Используйте "Я-сообщения": "Я чувствую..."
2. Говорите о фактах, не о личности
3. Слушайте, не перебивая

> Здоровый конфликт укрепляет доверие.

### Пример диалога

Вместо: "Ты никогда не помогаешь!"
Скажите: "Я чувствую себя перегруженной, когда убираюсь одна. Давай распределим обязанности?"

Конфликт — это мост к пониманию.
        ''',
        'featured': false,
      },
      {
        'title': 'Как создать утреннюю рутину для внутреннего покоя',
        'category': 'Медитация',
        'readTime': '7 мин',
        'date': '5 ноя 2024',
        'image': 'assets/images/article/evening.png',
        'color': const Color(0xFF9B59B6),
        'preview':
            'Начните день с заботы о себе — и весь день будет спокойнее.',
        'content': '''
# Утро задаёт тон всему дню

Как вы начинаете утро — так проходит день. 15 минут для себя = 8 часов спокойствия.

## Идеальная утренняя рутина

1. Проснуться без будильника (или с мягким)
2. Выпить стакан воды
3. 5 минут дыхания или медитации
4. Лёгкая растяжка
5. Записать 3 вещи, за которые благодарны

### Почему это работает?

- Вода активирует метаболизм
- Дыхание снижает кортизол
- Благодарность переключает мозг на позитив

> Утро — это ваш личный ритуал силы.

Не проверяйте телефон первые 30 минут — сохраните внутренний покой.
        ''',
        'featured': false,
      },
      {
        'title': 'Эмоциональный интеллект: зачем он нужен',
        'category': 'Эмоции',
        'readTime': '11 мин',
        'date': '3 ноя 2024',
        'image': 'assets/images/article/happy.png',
        'color': const Color(0xFF3498DB),
        'preview': 'EQ важнее IQ в 80% случаев успеха.',
        'content': '''
# EQ > IQ

Исследования показывают: эмоциональный интеллект определяет 80% успеха в жизни и карьере.

## 4 компонента EQ

1. **Самосознание** — понимать свои эмоции
2. **Саморегуляция** — управлять импульсами
3. **Эмпатия** — чувствовать других
4. **Социальные навыки** — строить отношения

### Как развивать?

- Ведите дневник эмоций
- Практикуйте активное слушание
- Задавайте вопрос: "Что я чувствую прямо сейчас?"

> Человек с высоким EQ зарабатывает на 29% больше.

Эмоции — не помеха. Это суперсила.
        ''',
        'featured': false,
      },
      {
        'title': 'Как перестать прокрастинировать',
        'category': 'Самопомощь',
        'readTime': '8 мин',
        'date': '1 ноя 2024',
        'image': 'assets/images/article/empty.png',
        'color': const Color(0xFFE74C3C),
        'preview': 'Прокрастинация — не лень. Это эмоции.',
        'content': '''
# Прокрастинация — это эмоция

Вы не ленитесь. Вы избегаете дискомфорта. Понимание этого — первый шаг.

## Техника "2 минуты"

Если задача занимает меньше 2 минут — сделайте её сразу.

### Техника "Помидоро"

- 25 минут работы
- 5 минут отдыха
- После 4 циклов — длинный перерыв

> Начало — это 80% успеха.

### Уберите триггеры

- Выключите уведомления
- Уберите телефон из поля зрения
- Подготовьте всё заранее

Действие создаёт мотивацию, а не наоборот.
        ''',
        'featured': false,
      },
      {
        'title': 'Границы в отношениях: как их ставить',
        'category': 'Отношения',
        'readTime': '10 мин',
        'date': '30 окт 2024',
        'image': 'assets/images/article/firelove.png',
        'color': const Color(0xFF1ABC9C),
        'preview': 'Здоровые границы — основа здоровых отношений.',
        'content': '''
# "Нет" — это полное предложение

Границы — это не стены. Это двери с замком, который открываете только вы.

## Как ставить границы?

1. Определите, что для вас неприемлемо
2. Скажите прямо: "Мне не комфортно, когда..."
3. Не оправдывайтесь
4. Будьте готовы к реакции

### Примеры фраз

- "Я не отвечаю на рабочие сообщения после 19:00"
- "Пожалуйста, не комментируй мой вес"
- "Мне нужно 30 минут в одиночестве после работы"

> Границы — это любовь к себе.

Без границ нет уважения. Ни к себе, ни от других.
        ''',
        'featured': false,
      },
      {
        'title': 'Сон и ментальное здоровье',
        'category': 'Популярное',
        'readTime': '9 мин',
        'date': '28 окт 2024',
        'image': 'assets/images/article/sleep.png',
        'color': const Color(0xFF34495E),
        'preview': 'Сон — не роскошь. Это необходимость.',
        'content': '''
# Сон лечит мозг

Во время сна мозг "промывает" себя от токсинов, включая бета-амилоид — маркер Альцгеймера.

## 7-9 часов — золотой стандарт

Меньше 6 часов:
- +77% риск депрессии
- +33% риск ожирения
- -29% концентрация

### Ритуал перед сном

1. За час до сна — без экранов
2. Тёмлый душ
3. Чтение бумажной книги
4. Температура в комнате 18-20°C

> Один час сна до полуночи = два после.

Сон — это инвестиция в завтрашний день.
        ''',
        'featured': false,
      },
      {
        'title': 'Как справляться с выгоранием',
        'category': 'Самопомощь',
        'readTime': '12 мин',
        'date': '25 окт 2024',
        'image': 'assets/images/article/depressed.png',
        'color': const Color(0xFFE67E22),
        'preview': 'Выгорание — это не слабость. Это сигнал.',
        'content': '''
# Выгорание — это не лень

Это истощение от хронического стресса. WHO признало его профессиональным феноменом.

## Признаки выгорания

- Постоянная усталость
- Цинизм и отстранённость
- Чувство неэффективности

### 3 шага к восстановлению

1. **Остановитесь** — возьмите выходной
2. **Восстановите ресурсы** — сон, еда, движение
3. **Пересмотрите приоритеты** — что можно делегировать?

> Выгорание лечится. Но не само.

Обратитесь за помощью. Это не слабость — это ответственность.
        ''',
        'featured': false,
      },
      {
        'title': 'Токсичные отношения: как распознать',
        'category': 'Отношения',
        'readTime': '11 мин',
        'date': '22 окт 2024',
        'image': 'assets/images/article/love.png',
        'color': const Color(0xFF9B59B6),
        'preview': 'Токсичность не всегда очевидна.',
        'content': '''
# Красные флаги токсичности

1. Постоянная критика
2. Контроль ("Где ты был?")
3. Газлайтинг ("Ты всё придумал")
4. Эмоциональные качели

## Как выйти?

- Осознайте: это не ваша вина
- Установите границы
- Обратитесь за поддержкой
- Планируйте выход

> Вы заслуживаете уважения.

Токсичные отношения крадут вашу энергию. Свобода — это подарок себе.
        ''',
        'featured': false,
      },
      {
        'title': 'Медитация для начинающих',
        'category': 'Медитация',
        'readTime': '6 мин',
        'date': '20 окт 2024',
        'image': 'assets/images/article/body.png',
        'color': const Color(0xFF2ECC71),
        'preview': 'Начните с 1 минуты в день.',
        'content': '''
# Медитация — это не сложно

Это просто внимание. К дыханию, телу, звукам.

## Практика за 3 шага

1. Сядьте удобно
2. Закройте глаза
3. Следите за дыханием

Мысли придут — это нормально. Не боритесь. Просто возвращайтесь.

> 1 минута в день = 1% спокойствия.

Приложения: Insight Timer, Calm, Headspace — на русском.

Медитация — это тренировка ума.
        ''',
        'featured': false,
      },
      {
        'title': 'Как говорить "нет" без чувства вины',
        'category': 'Эмоции',
        'readTime': '7 мин',
        'date': '18 окт 2024',
        'image': 'assets/images/article/givesad.png',
        'color': const Color(0xFFF39C12),
        'preview': '"Нет" — это забота о себе.',
        'content': '''
# "Нет" — это полное предложение

Вы не обязаны объяснять. Ваше время — ваша ценность.

## Как сказать "нет"?

- "Спасибо, но я не могу"
- "Сейчас не подходящее время"
- "Я ценю предложение, но откажусь"

### Почему мы боимся?

- Страх обидеть
- Желание быть нужным
- Воспитание

> Сказать "нет" чужому — сказать "да" себе.

Практикуйте. Сначала неловко — потом свободно.
        ''',
        'featured': false,
      },
      {
        'title': 'Самосаботаж: как его остановить',
        'category': 'Самопомощь',
        'readTime': '10 мин',
        'date': '15 окт 2024',
        'image': 'assets/images/article/sense.png',
        'color': const Color(0xFFC0392B),
        'preview': 'Вы — свой главный враг. Или друг?',
        'content': '''
# Самосаботаж — это защита

Вы откладываете, чтобы не столкнуться с провалом. Но провал — это урок.

## Как остановить?

1. Замените "я должен" на "я выбираю"
2. Делите задачи на микрошаги
3. Хвалите себя за прогресс

> Перфекционизм — это страх быть обычным.

Сделанное лучше, чем идеальное.
        ''',
        'featured': false,
      },
      {
        'title': 'Как строить доверие в команде',
        'category': 'Популярное',
        'readTime': '9 мин',
        'date': '12 окт 2024',
        'image': 'assets/images/article/whyIlove.png',
        'color': const Color(0xFF8E44AD),
        'preview': 'Доверие — основа любой команды.',
        'content': '''
# Доверие строится действиями

1. Будьте уязвимы первыми
2. Признавайте ошибки
3. Слушайте, не перебивая
4. Держите слово

> Команда с доверием работает на 50% эффективнее.

Google изучил 180 команд: психологическая безопасность — ключ к успеху.
        ''',
        'featured': false,
      },
      {
        'title': 'Эмоции на работе: как не сгореть',
        'category': 'Эмоции',
        'readTime': '8 мин',
        'date': '10 окт 2024',
        'image': 'assets/images/article/sad.png',
        'color': const Color(0xFF2980B9),
        'preview': 'Эмоции на работе — это нормально.',
        'content': '''
# Назови эмоцию — и она потеряет силу

"Я злюсь", "Я расстроен" — это не слабость. Это осознанность.

## Техники

- 90-секундное правило: эмоция длится 90 сек
- Дыхание перед ответом
- Письмо коллегам: "Я ценю..."

> Эмоциональная открытость повышает лояльность.

Работа — это люди. А люди — это эмоции.
        ''',
        'featured': false,
      },
      {
        'title': 'Как найти баланс между работой и жизнью',
        'category': 'Популярное',
        'readTime': '11 мин',
        'date': '8 окт 2024',
        'image': 'assets/images/article/empty.png',
        'color': const Color(0xFF27AE60),
        'preview': 'Баланс — это не 50/50. Это 100/100.',
        'content': '''
# Работайте, чтобы жить

Не живите, чтобы работать.

## Практические шаги

1. Определите приоритеты
2. Установите границы (выходные — без почты)
3. Планируйте отдых как встречу
4. Говорите "нет" лишнему

> Усталость — не знак успеха.

Баланс — это энергия для важного.
        ''',
        'featured': false,
      },
      {
        'title': 'Как справляться с критикой',
        'category': 'Эмоции',
        'readTime': '7 мин',
        'date': '5 окт 2024',
        'image': 'assets/images/article/dontAgro.png',
        'color': const Color(0xFFE74C3C),
        'preview': 'Критика — это не приговор.',
        'content': '''
# Критика — это данные

Не о вас. О поведении.

## Как реагировать?

1. Слушайте молча
2. Задайте вопрос: "Что я могу улучшить?"
3. Благодарю за обратную связь
4. Решите, что взять

> Конструктивная критика — подарок.

Личная атака — отражение критика.
        ''',
        'featured': false,
      },
    ];
  }
}

// СТРАНИЦА ЧТЕНИЯ — ПОЛНЫЙ ТЕКСТ
class ArticleReaderPage extends StatefulWidget {
  final Map<String, dynamic> article;
  const ArticleReaderPage({super.key, required this.article});

  @override
  State<ArticleReaderPage> createState() => _ArticleReaderPageState();
}

class _ArticleReaderPageState extends State<ArticleReaderPage> {
  final ScrollController _scrollController = ScrollController();
  double _readingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      setState(() => _readingProgress = (current / max).clamp(0.0, 1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      body: Column(
        children: [
          // Progress bar
          SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: _readingProgress,
              backgroundColor: AppColors.inputBackground,
              valueColor: AlwaysStoppedAnimation(widget.article['color'] as Color),
            ),
          ),
          // Back button for mobile
          if (isMobile)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      'Назад к статьям',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                margin: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 60,
                  vertical: isMobile ? 20 : 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isMobile ? 24 : 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
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
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: (widget.article['color'] as Color)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.article['category'] as String,
                              style: AppTextStyles.body1.copyWith(
                                color: widget.article['color'] as Color,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.article['title'] as String,
                            style: AppTextStyles.h1.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              fontSize: isMobile ? 28 : 38,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(Icons.access_time_outlined,
                                  size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                widget.article['readTime'] as String,
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Icon(Icons.calendar_today_outlined,
                                  size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(
                                widget.article['date'] as String,
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
                    // Article content
                    Container(
                      padding: EdgeInsets.all(isMobile ? 24 : 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildArticleContent(
                          widget.article['content'] as String),
                    ),
                    const SizedBox(height: 32),
                    // Bottom buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isMobile)
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: AppColors.inputBorder),
                              ),
                            ),
                            icon:
                                const Icon(Icons.arrow_back, size: 18),
                            label: Text(
                              'Назад к статьям',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ElevatedButton.icon(
                          onPressed: () => _shareArticle(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.article['color'] as Color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.share,
                              color: Colors.white, size: 18),
                          label: Text(
                            'Поделиться',
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('# ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 14),
            child: Text(
              line.substring(2),
              style: AppTextStyles.h1.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          );
        } else if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 10),
            child: Text(
              line.substring(3),
              style: AppTextStyles.h2.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          );
        } else if (line.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 8),
            child: Text(
              line.substring(4),
              style: AppTextStyles.h3.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          );
        } else if (line.startsWith('- ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, right: 10),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: widget.article['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 15.5,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (line.trim().isEmpty) {
          return const SizedBox(height: 14);
        } else if (line.startsWith('> ')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              line.substring(2),
              style: AppTextStyles.body1.copyWith(
                fontSize: 16,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              line,
              style: AppTextStyles.body1.copyWith(
                fontSize: 15.5,
                height: 1.55,
                color: AppColors.textPrimary,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  void _shareArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Поделиться статьей',
          style: AppTextStyles.h2,
        ),
        content: Text(
          'Ссылка скопирована в буфер обмена!',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Закрыть',
              style: AppTextStyles.body1.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}