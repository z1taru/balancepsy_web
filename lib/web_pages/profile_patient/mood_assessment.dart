// lib/web_pages/profile_patient/mood_assessment.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class MoodModel {
  final String id;
  final String name;
  final String emoji;
  final String imagePath;
  final String description;
  final Color color;

  MoodModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.imagePath,
    required this.description,
    required this.color,
  });
}

class MoodQuestion {
  final String id;
  final String question;
  final List<String> options;

  MoodQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

class MoodAssessmentPage extends StatefulWidget {
  const MoodAssessmentPage({super.key});

  @override
  State<MoodAssessmentPage> createState() => _MoodAssessmentPageState();
}

class _MoodAssessmentPageState extends State<MoodAssessmentPage> {
  int _currentStep = 0;
  int _selectedMoodIndex = -1;
  List<int> _testAnswers = [];
  double _progressValue = 0.0;

  final List<MoodModel> _moods = [
    MoodModel(
      id: '1',
      name: 'Эйфория',
      emoji: '😄',
      imagePath: 'assets/images/mood/mood_overjoyed.png',
      description: 'Отличное настроение! Полон энергии и радости',
      color: const Color(0xFFFFD700),
    ),
    MoodModel(
      id: '2',
      name: 'Радость',
      emoji: '😊',
      imagePath: 'assets/images/mood/mood_happy.png',
      description: 'Чувствую себя хорошо и позитивно',
      color: const Color(0xFF4CAF50),
    ),
    MoodModel(
      id: '3',
      name: 'Спокойствие',
      emoji: '😌',
      imagePath: 'assets/images/mood/mood_neutral.png',
      description: 'Внутренняя гармония и баланс',
      color: const Color(0xFF2196F3),
    ),
    MoodModel(
      id: '4',
      name: 'Грусть',
      emoji: '😔',
      imagePath: 'assets/images/mood/mood_sad.png',
      description: 'Чувствую легкую печаль',
      color: const Color(0xFF607D8B),
    ),
    MoodModel(
      id: '5',
      name: 'Подавленность',
      emoji: '😞',
      imagePath: 'assets/images/mood/mood_depressed.png',
      description: 'Тяжело на душе, нужна поддержка',
      color: const Color(0xFF673AB7),
    ),
  ];

  final List<MoodQuestion> _questions = [
    MoodQuestion(
      id: '1',
      question: 'Как хорошо вы спали прошлой ночью?',
      options: ['Очень хорошо', 'Нормально', 'Плохо', 'Очень плохо'],
    ),
    MoodQuestion(
      id: '2',
      question: 'Насколько вы чувствуете энергию сегодня?',
      options: ['Полон энергии', 'Нормально', 'Устал', 'Очень устал'],
    ),
    MoodQuestion(
      id: '3',
      question: 'Как часто вас посещают позитивные мысли?',
      options: ['Постоянно', 'Часто', 'Иногда', 'Редко'],
    ),
    MoodQuestion(
      id: '4',
      question: 'Насколько легко вам концентрироваться?',
      options: ['Очень легко', 'Нормально', 'Сложно', 'Очень сложно'],
    ),
    MoodQuestion(
      id: '5',
      question: 'Как вы оцениваете свое общее самочувствие?',
      options: ['Отлично', 'Хорошо', 'Нормально', 'Плохо'],
    ),
  ];

  void _nextStep() {
    setState(() {
      _currentStep++;
      _progressValue = _currentStep / (_questions.length + 1);
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
      _progressValue = _currentStep / (_questions.length + 1);
    });
  }

  void _selectMood(int index) {
    setState(() {
      _selectedMoodIndex = index;
    });
    _nextStep();
  }

  void _selectTestAnswer(int questionIndex, int answerIndex) {
    setState(() {
      if (_testAnswers.length <= questionIndex) {
        _testAnswers.add(answerIndex);
      } else {
        _testAnswers[questionIndex] = answerIndex;
      }
    });
    
    if (questionIndex < _questions.length - 1) {
      _nextStep();
    } else {
      _nextStep(); // Переход к результатам
    }
  }

  void _completeAssessment() {
    // Здесь можно сохранить результаты в базу данных
    Navigator.pop(context);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 320, // Фиксированная ширина
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 30, color: AppColors.success),
              ),
              const SizedBox(height: 16),
              Text(
                'Спасибо за вашу оценку!',
                style: AppTextStyles.h3.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Ваше настроение сохранено. Мы подготовили персонализированные рекомендации для вас.',
                style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Отлично!', style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRecommendation(int moodIndex, int score) {
    if (moodIndex <= 1) { // Эйфория или Радость
      return 'Продолжайте в том же духе! Рекомендуем поделиться своим позитивом с близкими и заняться творчеством.';
    } else if (moodIndex == 2) { // Спокойствие
      return 'Отличное состояние гармонии! Попробуйте медитацию для поддержания баланса.';
    } else if (moodIndex == 3) { // Грусть
      return 'Рекомендуем прогулку на свежем воздухе, прослушивание любимой музыки и общение с друзьями.';
    } else { // Подавленность
      return 'Важно заботиться о себе. Рекомендуем обратиться к специалисту и практиковать дыхательные упражнения.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 500, // Фиксированная ширина основного окна
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок и кнопка закрытия
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Оценка настроения',
                        style: AppTextStyles.h3.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              // Прогресс бар
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressValue,
                        backgroundColor: AppColors.inputBorder.withOpacity(0.3),
                        color: AppColors.primary,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((_progressValue) * 100).toInt()}% завершено',
                      style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: _buildCurrentStep(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildMoodSelection();
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return _buildTestQuestion(_currentStep - 1);
      case 6:
        return _buildResults();
      default:
        return _buildMoodSelection();
    }
  }

  Widget _buildMoodSelection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.backgroundLight,
      ),
      child: Column(
        children: [
          Text(
            'Как вы себя чувствуете сегодня?',
            style: AppTextStyles.h2.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите эмоцию, которая лучше всего описывает ваше текущее состояние',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                final mood = _moods[index];
                return _buildMoodCard(mood, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(MoodModel mood, int index) {
    final isSelected = _selectedMoodIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectMood(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? mood.color.withOpacity(0.2) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? mood.color : AppColors.inputBorder.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(isSelected ? 0.1 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(mood.imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                mood.emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                mood.name,
                style: AppTextStyles.body3.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? mood.color : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestQuestion(int questionIndex) {
    final question = _questions[questionIndex];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.backgroundLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вопрос ${questionIndex + 1}/${_questions.length}',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question.question,
            style: AppTextStyles.h3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final isSelected = _testAnswers.length > questionIndex && 
                    _testAnswers[questionIndex] == index;
                return _buildAnswerOption(question.options[index], index, isSelected, questionIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(String option, int index, bool isSelected, int questionIndex) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectTestAnswer(questionIndex, index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.inputBorder.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(isSelected ? 0.08 : 0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final selectedMood = _selectedMoodIndex >= 0 ? _moods[_selectedMoodIndex] : _moods[2];
    final positiveAnswers = _testAnswers.where((answer) => answer <= 1).length; // Первые два варианта - позитивные
    final moodScore = (positiveAnswers / _questions.length * 100).toInt();
    final recommendation = _getRecommendation(_selectedMoodIndex, moodScore);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.backgroundLight,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selectedMood.color.withOpacity(0.3), width: 2),
                image: DecorationImage(
                  image: AssetImage(selectedMood.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ваше настроение сегодня',
              style: AppTextStyles.h3.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              selectedMood.name,
              style: AppTextStyles.h2.copyWith(
                fontSize: 24,
                color: selectedMood.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              selectedMood.description,
              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Результаты теста
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Результаты теста',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: moodScore / 100,
                      backgroundColor: AppColors.inputBorder,
                      color: _getScoreColor(moodScore),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$moodScore% позитивных показателей',
                    style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Вы ответили на ${_testAnswers.length} из ${_questions.length} вопросов',
                    style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Рекомендации
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Персонализированные рекомендации',
                        style: AppTextStyles.body2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recommendation,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeAssessment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Завершить оценку',
                  style: AppTextStyles.button.copyWith(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFFFFC107);
    if (score >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}