import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../widgets/web_layout.dart';
import '../../../widgets/custom_button.dart';
import '../../../providers/user_provider.dart';

class PsychologistsPage extends StatefulWidget {
  const PsychologistsPage({super.key});

  @override
  State<PsychologistsPage> createState() => _PsychologistsPageState();
}

class _PsychologistsPageState extends State<PsychologistsPage> {
  String _selectedSpecialization = 'Все';
  String _selectedExperience = 'Любой';
  String _selectedPrice = 'Любая';

  final List<String> _specializations = [
    'Все',
    'Тревожность',
    'Депрессия',
    'Отношения',
    'Самооценка',
    'Стресс',
    'Выгорание',
    'Панические атаки',
    'Семейная терапия',
    'Детская психология',
  ];

  final List<String> _experiences = ['Любой', '1-3 года', '3-5 лет', '5+ лет'];
  final List<String> _prices = [
    'Любая',
    'до 10 000 ₸',
    '10-15 000 ₸',
    '15 000+ ₸',
  ];

  final List<Map<String, dynamic>> _psychologists = [];

  List<Map<String, dynamic>> get _filteredPsychologists {
    List<Map<String, dynamic>> result = List.from(_psychologists);

    if (_selectedSpecialization != 'Все') {
      result = result.where((p) {
        final helps = p['helps'] as List<String>;
        return helps.contains(_selectedSpecialization);
      }).toList();
    }

    if (_selectedExperience != 'Любой') {
      result = result.where((p) {
        final exp = p['experienceNum'] as int;
        if (_selectedExperience == '1-3 года') return exp >= 1 && exp <= 3;
        if (_selectedExperience == '3-5 лет') return exp >= 3 && exp <= 5;
        if (_selectedExperience == '5+ лет') return exp >= 5;
        return true;
      }).toList();
    }

    if (_selectedPrice != 'Любая') {
      result = result.where((p) {
        final price = p['priceNum'] as int;
        if (_selectedPrice == 'до 10 000 ₸') return price <= 10000;
        if (_selectedPrice == '10-15 000 ₸')
          return price > 10000 && price <= 15000;
        if (_selectedPrice == '15 000+ ₸') return price > 15000;
        return true;
      }).toList();
    }

    return result;
  }

  void _resetFilters() {
    setState(() {
      _selectedSpecialization = 'Все';
      _selectedExperience = 'Любой';
      _selectedPrice = 'Любая';
    });
  }

  // ─── Guard: проверка перед переходом в detail ───────────────────
  /// Возвращает true, если навигация разрешена (авторизован, не психолог).
  /// Иначе — показывает снэкбар или редирект и возвращает false.
  bool _guardNavigation(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!userProvider.isAuthenticated) {
      Navigator.pushNamed(context, AppRouter.login);
      return false;
    }

    if (userProvider.userRole == 'PSYCHOLOGIST') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Психологи не могут записываться на консультации'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return PageWrapper(
      currentRoute: AppRouter.psychologists,
      child: Column(
        children: [
          _buildHeroSection(isMobile, isTablet),
          _buildStatsSection(isMobile, isTablet),
          _buildFiltersSection(isMobile, isTablet),
          _buildPsychologistsGrid(isMobile, isTablet),
          _buildCTASection(isMobile, isTablet),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HERO
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeroSection(bool isMobile, bool isTablet) {
    final isDesktop = !isMobile && !isTablet;

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
        child: Column(
          children: [
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroTag(),
                        const SizedBox(height: 24),
                        Text(
                          'Наши психологи — ваши проводники к балансу',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Каждый специалист проходит строгий отбор, имеет высшее образование, сертификаты и регулярно повышает квалификацию. Мы подберем психолога именно под ваш запрос.',
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 20,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 600,
                      child: SvgPicture.asset(
                        'assets/images/main_page/woman.svg',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildHeroTag(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Наши психологи — ваши проводники к балансу',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: isMobile ? 32 : 48,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Каждый специалист проходит строгий отбор, имеет высшее образование, сертификаты и регулярно повышает квалификацию. Мы подберем психолога именно под ваш запрос.',
                      style: AppTextStyles.body1.copyWith(
                        fontSize: isMobile ? 18 : 20,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 60),
            if (!isMobile)
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _buildHeroFeature(
                    '🎯',
                    'Индивидуальный подбор',
                    'под ваш запрос и цели',
                  ),
                  _buildHeroFeature(
                    '⭐',
                    'Только проверенные',
                    'специалисты с опытом 3+ лет',
                  ),
                  _buildHeroFeature(
                    '💼',
                    'Лицензии и сертификаты',
                    'подтвержденная квалификация',
                  ),
                  _buildHeroFeature(
                    '💬',
                    'Бесплатная поддержка',
                    'помощь с выбором психолога',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        'Команда экспертов',
        style: AppTextStyles.body1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHeroFeature(String emoji, String title, String subtitle) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.all(20),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStatsSection(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: 40,
        ),
        child: Wrap(
          spacing: isMobile ? 20 : 40,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildStatItem('${_psychologists.length}', 'Психологов в команде'),
            Container(width: 1, height: 40, color: AppColors.inputBorder),
            _buildStatItem('1500+', 'Консультаций в месяц'),
            Container(width: 1, height: 40, color: AppColors.inputBorder),
            _buildStatItem('4.8', 'Средний рейтинг'),
            Container(width: 1, height: 40, color: AppColors.inputBorder),
            _buildStatItem('98%', 'Довольных клиентов'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              fontSize: 36,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FILTERS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFiltersSection(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundLight,
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Найдите своего психолога',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Отфильтруйте специалистов по нужным критериям',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isMobile ? 16 : 18,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextButton(
                      onPressed: _resetFilters,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Сбросить фильтры',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            // Специализации
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Специализация',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _specializations.map((spec) {
                    final isSelected = spec == _selectedSpecialization;
                    return FilterChip(
                      label: Text(spec),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(
                          () =>
                              _selectedSpecialization = selected ? spec : 'Все',
                        );
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primary,
                      labelStyle: AppTextStyles.body1.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.inputBorder,
                        ),
                      ),
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Опыт + цена
            if (!isMobile)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFilterGroup(
                      'Опыт работы',
                      _experiences,
                      _selectedExperience,
                      'Любой',
                      (v) => setState(() => _selectedExperience = v),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: _buildFilterGroup(
                      'Цена за сессию',
                      _prices,
                      _selectedPrice,
                      'Любая',
                      (v) => setState(() => _selectedPrice = v),
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterGroup(
                    'Опыт работы',
                    _experiences,
                    _selectedExperience,
                    'Любой',
                    (v) => setState(() => _selectedExperience = v),
                  ),
                  const SizedBox(height: 24),
                  _buildFilterGroup(
                    'Цена за сессию',
                    _prices,
                    _selectedPrice,
                    'Любая',
                    (v) => setState(() => _selectedPrice = v),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            if (isMobile)
              Center(
                child: CustomButton(
                  text: 'Сбросить фильтры',
                  onPressed: _resetFilters,
                  isPrimary: false,
                  isFullWidth: false,
                  icon: Icons.refresh,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGroup(
    String title,
    List<String> items,
    String selected,
    String defaultVal,
    void Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            final isSelected = item == selected;
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (sel) => onSelect(sel ? item : defaultVal),
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: AppTextStyles.body1.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                ),
              ),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // GRID
  // ═══════════════════════════════════════════════════════════════
  Widget _buildPsychologistsGrid(bool isMobile, bool isTablet) {
    final filtered = _filteredPsychologists;

    return Container(
      width: double.infinity,
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 40 : 60,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} ${_getCorrectWord(filtered.length)}',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!isMobile)
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
                      '${filtered.length} из ${_psychologists.length}',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            filtered.isEmpty
                ? _buildEmptyState(isMobile)
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                      crossAxisSpacing: isMobile ? 0 : 24,
                      mainAxisSpacing: isMobile ? 24 : 32,
                      childAspectRatio: isMobile ? 1.3 : 0.85,
                      mainAxisExtent: isMobile ? null : 520,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _buildPsychologistCard(filtered[index], isMobile),
                  ),
          ],
        ),
      ),
    );
  }

  String _getCorrectWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'психолог';
    if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20))
      return 'психолога';
    return 'психологов';
  }

  Widget _buildEmptyState(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 100,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Психологов не найдено',
            style: AppTextStyles.h3.copyWith(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isMobile ? double.infinity : 400,
            child: Text(
              'Попробуйте изменить фильтры или выбрать другие параметры поиска',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 16 : 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: isMobile ? double.infinity : 200,
            child: CustomButton(
              text: 'Сбросить фильтры',
              onPressed: _resetFilters,
              isPrimary: true,
              isFullWidth: true,
              icon: Icons.refresh,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Карточка психолога ────────────────────────────────────────
  Widget _buildPsychologistCard(
    Map<String, dynamic> psychologist,
    bool isMobile,
  ) {
    final isAvailable = psychologist['available'] as bool;
    final id = psychologist['id'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Фото + бейдж ──
          SizedBox(
            height: isMobile ? 200 : 220,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    psychologist['photo'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary.withOpacity(0.05),
                      child: Center(
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 80,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      if (!isAvailable)
                        _buildBadge(
                          'Занято',
                          AppColors.error.withOpacity(0.9),
                          Colors.white,
                        ),
                      ...(psychologist['tags'] as List<String>).map(
                        (tag) => _buildBadge(
                          tag,
                          Colors.white.withOpacity(0.9),
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${psychologist['rating']}',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Информация ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          psychologist['name'],
                          style: AppTextStyles.h3.copyWith(
                            fontSize: isMobile ? 20 : 22,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          psychologist['specialization'],
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          psychologist['description'],
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppColors.inputBorder.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMiniRow(
                                Icons.work_history_outlined,
                                psychologist['experience'],
                              ),
                              const SizedBox(height: 4),
                              _buildMiniRow(
                                Icons.message_outlined,
                                '${psychologist['reviews']} отзывов',
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'от ${psychologist['price']} ₸',
                                style: AppTextStyles.h3.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'за ${psychologist['sessionDuration']}',
                                style: AppTextStyles.body3.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ─── ИЗМЕНЕНИЕ: кнопка всегда ведёт на detail ───
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: CustomButton(
                          text: 'Записаться',
                          onPressed: () {
                            // Guard: если не авторизован или психолог — не идём дальше
                            if (!_guardNavigation(context)) return;
                            // Навигация ТОЛЬКО на detail
                            Navigator.pushNamed(context, '/psychologists/$id');
                          },
                          isPrimary: true,
                          isFullWidth: true,
                          icon: Icons.arrow_forward_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: AppTextStyles.body3.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMiniRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.body2.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CTA
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCTASection(bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.primaryLight.withOpacity(0.08),
          ],
        ),
      ),
      child: WebLayout.content(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 80,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Нужна помощь с выбором?',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Наши консультанты помогут подобрать психолога именно под ваш запрос, цели и бюджет. Мы учтем все нюансы и предложим лучших специалистов.',
                      style: AppTextStyles.body1.copyWith(
                        fontSize: isMobile ? 16 : 18,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: isMobile ? 16 : 24,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildBenefitItem('✓ Бесплатная консультация по подбору'),
                      _buildBenefitItem('✓ Подбор по 5+ параметрам'),
                      _buildBenefitItem('✓ Помощь в записи на первую сессию'),
                      _buildBenefitItem('✓ Поддержка на всех этапах'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: isMobile ? double.infinity : 280,
                    height: 56,
                    child: CustomButton(
                      text: 'Подобрать психолога',
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.contacts),
                      isPrimary: true,
                      isFullWidth: true,
                      icon: Icons.psychology_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
