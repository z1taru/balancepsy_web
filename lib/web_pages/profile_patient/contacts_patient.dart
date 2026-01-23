// lib/web_pages/profile_patient/contacts_patient.dart

import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../widgets/profile_patient/patient_bar.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../сore/router/app_router.dart';

class ContactsPatientPage extends StatefulWidget {
  const ContactsPatientPage({super.key});

  @override
  State<ContactsPatientPage> createState() => _ContactsPatientPageState();
}

class _ContactsPatientPageState extends State<ContactsPatientPage> {
  String _selectedCategory = 'Все';
  String _searchQuery = '';
  String _sortBy = 'rating';

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фиксированный сайдбар, который не скролится
          Container(
            width: 280,
            child: PatientBar(currentRoute: AppRouter.contactsPatient),
          ),
          // Основной контент с возможностью скролла
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                margin: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    _buildCategoriesFilter(),
                    const SizedBox(height: 32),
                    _buildPsychologistsGrid(ctx),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Каталог психологов', style: AppTextStyles.h1.copyWith(fontSize: 36)),
        const SizedBox(height: 12),
        Text(
          'Выберите специалиста для консультации',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Поиск психологов по имени, специализации...',
                hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                suffixIcon: Icon(Icons.search, color: AppColors.textTertiary),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.inputBorder,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showSortDialog,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 60,
                child: Row(
                  children: [
                    Icon(Icons.sort, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      _getSortButtonText(),
                      style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortButtonText() {
    switch (_sortBy) {
      case 'rating':
        return 'По рейтингу';
      case 'price':
        return 'По цене';
      case 'experience':
        return 'По опыту';
      default:
        return 'Сортировка';
    }
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Сортировка', style: AppTextStyles.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('По рейтингу', 'rating', Icons.star),
            _buildSortOption('По цене', 'price', Icons.attach_money),
            _buildSortOption('По опыту', 'experience', Icons.work),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.body1),
      trailing: _sortBy == value ? Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCategoriesFilter() {
    final categories = [
      {'name': 'Все', 'count': 12},
      {'name': 'КПТ', 'count': 4},
      {'name': 'Гештальт', 'count': 3},
      {'name': 'Психоанализ', 'count': 2},
      {'name': 'Семейная', 'count': 2},
      {'name': 'Детская', 'count': 1},
    ];

    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = _selectedCategory == category['name'];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedCategory = category['name'] as String;
                });
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.inputBorder.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category['name'] as String,
                      style: AppTextStyles.body1.copyWith(
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (category['count'] as int).toString(),
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

  Widget _buildPsychologistsGrid(BuildContext ctx) {
    List<Map<String, dynamic>> filteredPsychologists = _getFilteredAndSortedPsychologists();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${filteredPsychologists.length} специалистов',
              style: AppTextStyles.h2,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.sort, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    _getSortButtonText(),
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.08,
          ),
          itemCount: filteredPsychologists.length,
          itemBuilder: (ctx, index) {
            final psychologist = filteredPsychologists[index];
            return _buildPsychologistCard(ctx, psychologist);
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredAndSortedPsychologists() {
    List<Map<String, dynamic>> allPsychologists = _getAllPsychologists();

    List<Map<String, dynamic>> filtered = allPsychologists.where((psychologist) {
      final matchesCategory = _selectedCategory == 'Все' ||
          psychologist['specializations'].contains(_selectedCategory);
      final matchesSearch = _searchQuery.isEmpty ||
          psychologist['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          psychologist['specializations']
              .any((spec) => spec.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          psychologist['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        case 'price':
          final priceA = int.parse((a['price'] as String).replaceAll(' ', ''));
          final priceB = int.parse((b['price'] as String).replaceAll(' ', ''));
          return priceA.compareTo(priceB);
        case 'experience':
          final expA = int.parse((a['experience'] as String).replaceAll(RegExp(r'[^0-9]'), ''));
          final expB = int.parse((b['experience'] as String).replaceAll(RegExp(r'[^0-9]'), ''));
          return expB.compareTo(expA);
        default:
          return 0;
      }
    });

    return filtered;
  }

  Widget _buildPsychologistCard(BuildContext ctx, Map<String, dynamic> psychologist) {
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
          onTap: () => _showPsychologistDetails(ctx, psychologist),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                        image: DecorationImage(
                          image: AssetImage(psychologist['avatar']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            psychologist['name'],
                            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            psychologist['experience'],
                            style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          _buildRating(psychologist['rating']),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: psychologist['specializations'].map<Widget>((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        spec,
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  psychologist['description'],
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${psychologist['price']} ₸',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'за сеанс',
                          style: AppTextStyles.body3.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _showBookingDialog(ctx, psychologist),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Выбрать', style: AppTextStyles.button),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text(
          '(${(rating * 10).toInt()})',
          style: AppTextStyles.body3.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  void _showPsychologistDetails(BuildContext ctx, Map<String, dynamic> psychologist) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Профиль специалиста', style: AppTextStyles.h2),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 3),
                        image: DecorationImage(
                          image: AssetImage(psychologist['avatar']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(psychologist['name'], style: AppTextStyles.h2),
                          const SizedBox(height: 8),
                          Text(
                            psychologist['experience'],
                            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          _buildRating(psychologist['rating']),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: psychologist['specializations'].map<Widget>((spec) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  spec,
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  psychologist['fullDescription'],
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${psychologist['price']} ₸',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            'Стоимость одной консультации',
                            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBookingDialog(ctx, psychologist);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Записаться на консультацию',
                          style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext ctx, Map<String, dynamic> psychologist) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Запись к специалисту', style: AppTextStyles.h2),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(psychologist['avatar']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          psychologist['name'],
                          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          psychologist['experience'],
                          style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${psychologist['price']} ₸',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите дату и время:',
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Выберите удобное время...',
                              style: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.calendar_today_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ваш комментарий (необязательно):',
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Опишите вашу проблему или вопросы...',
                        hintStyle: AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar(ctx, psychologist['name']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Подтвердить запись',
                  style: AppTextStyles.button.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext ctx, String name) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Запись к $name успешно создана!'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  List<Map<String, dynamic>> _getAllPsychologists() {
    return [
      {
        'name': 'Доктор Айгерим Сапарбекова',
        'experience': 'Опыт работы: 8 лет',
        'rating': 4.9,
        'price': '15 000',
        'avatar': 'assets/images/avatar/aigerim.png',
        'specializations': ['КПТ', 'Тревожность', 'Депрессия'],
        'description':
            'Специализируется на когнитивно-поведенческой терапии. Помогает справляться с тревожными расстройствами.',
        'fullDescription':
            'Сертифицированный психолог с 8-летним опытом работы в области когнитивно-поведенческой терапии. Специализируется на работе с тревожными расстройствами, депрессией и паническими атаками. Использует научно-доказанные методы терапии.',
      },
      {
        'name': 'Галия Канаева',
        'experience': 'Опыт работы: 6 лет',
        'rating': 4.8,
        'price': '12 000',
        'avatar': 'assets/images/avatar/galiya.png',
        'specializations': ['Гештальт', 'Отношения', 'Самооценка'],
        'description': 'Гештальт-терапевт. Работает с проблемами в отношениях и самооценкой.',
        'fullDescription':
            'Опытный гештальт-терапевт с 6-летним стажем. Помогает клиентам в решении проблем в отношениях, повышении самооценки и поиске гармонии с собой. Работает в технике диалога и экспериментов.',
      },
      {
        'name': 'Лаура Жумабекова',
        'experience': 'Опыт работы: 10 лет',
        'rating': 5.0,
        'price': '18 000',
        'avatar': 'assets/images/avatar/laura2.png',
        'specializations': ['Психоанализ', 'Травма', 'Личностный рост'],
        'description':
            'Психоаналитик с 10-летним опытом. Работает с глубокими личностными проблемами.',
        'fullDescription':
            'Дипломированный психоаналитик с 10-летним опытом работы. Специализируется на работе с травматическим опытом, личностными кризисами и глубинными проблемами. Использует классический психоаналитический подход.',
      },
    ];
  }
}