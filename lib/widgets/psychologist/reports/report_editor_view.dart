import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../models/report_model.dart';
import '../../../core/services/reports_service.dart';
import 'dart:async';

class ReportEditorView extends StatefulWidget {
  final int reportId;
  final VoidCallback onBack;

  const ReportEditorView({
    super.key,
    required this.reportId,
    required this.onBack,
  });

  @override
  State<ReportEditorView> createState() => _ReportEditorViewState();
}

class _ReportEditorViewState extends State<ReportEditorView> {
  final ReportsService _service = ReportsService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _themeController;
  late TextEditingController _descriptionController;
  late TextEditingController _recommendationsController;

  ReportModel? _report;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _themeController = TextEditingController();
    _descriptionController = TextEditingController();
    _recommendationsController = TextEditingController();

    _loadReport();
    _startAutoSave();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _themeController.dispose();
    _descriptionController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_hasChanges &&
          !_isSaving &&
          _report != null &&
          !_report!.isCompleted) {
        _saveDraft();
      }
    });
  }

  Future<void> _loadReport() async {
    try {
      setState(() => _isLoading = true);

      final report = await _service.getReportById(widget.reportId);

      setState(() {
        _report = report;
        _themeController.text = report.sessionTheme;
        _descriptionController.text = report.sessionDescription;
        _recommendationsController.text = report.recommendations ?? '';
        _isLoading = false;
      });

      _themeController.addListener(_onFieldChanged);
      _descriptionController.addListener(_onFieldChanged);
      _recommendationsController.addListener(_onFieldChanged);
    } catch (e) {
      print('❌ Error loading report: $e');
      setState(() => _isLoading = false);
      _showError('Не удалось загрузить отчёт');
    }
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _saveDraft() async {
    if (_report == null || _report!.isCompleted) return;

    try {
      setState(() => _isSaving = true);

      await _service.updateReport(
        widget.reportId,
        sessionTheme: _themeController.text,
        sessionDescription: _descriptionController.text,
        recommendations: _recommendationsController.text,
        isCompleted: false,
      );

      setState(() {
        _hasChanges = false;
        _isSaving = false;
      });

      _showSuccess('Черновик сохранён');
    } catch (e) {
      print('❌ Error saving draft: $e');
      setState(() => _isSaving = false);
      _showError('Не удалось сохранить черновик');
    }
  }

  Future<void> _completeReport() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Заполните все обязательные поля');
      return;
    }

    // Подтверждение
    final confirmed = await _showConfirmDialog(
      'Завершить отчёт?',
      'После завершения отчёт нельзя будет редактировать',
    );

    if (!confirmed) return;

    try {
      setState(() => _isSaving = true);

      final updatedReport = await _service.updateReport(
        widget.reportId,
        sessionTheme: _themeController.text,
        sessionDescription: _descriptionController.text,
        recommendations: _recommendationsController.text,
        isCompleted: true,
      );

      setState(() {
        _report = updatedReport;
        _hasChanges = false;
        _isSaving = false;
      });

      _showSuccess('Отчёт завершён');
    } catch (e) {
      print('❌ Error completing report: $e');
      setState(() => _isSaving = false);
      _showError('Не удалось завершить отчёт');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_report == null) {
      return _buildErrorState();
    }

    final isViewMode = _report!.isCompleted;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumbs(),
            const SizedBox(height: 24),
            _buildHeader(isViewMode),
            const SizedBox(height: 32),
            _buildClientCard(),
            const SizedBox(height: 24),
            _buildReportForm(isViewMode),
            const SizedBox(height: 24),
            if (!isViewMode) _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        InkWell(
          onTap: widget.onBack,
          child: Row(
            children: [
              const Icon(Icons.arrow_back, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'К списку отчётов',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isViewMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    isViewMode ? 'Просмотр отчёта' : 'Редактирование отчёта',
                    style: AppTextStyles.h1.copyWith(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusBadge(_report!.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _report!.formattedDate,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (_hasChanges && !isViewMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (_isSaving)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange,
                    ),
                  )
                else
                  const Icon(Icons.edit, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  _isSaving ? 'Сохранение...' : 'Есть изменения',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(ReportStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case ReportStatus.completed:
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = '✅ Готов';
        break;
      case ReportStatus.draft:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = '🟡 Черновик';
        break;
      case ReportStatus.pending:
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        text = '⚠️ Требуется';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildClientCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: _report!.clientAvatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      _report!.clientAvatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarPlaceholder(_report!.clientName);
                      },
                    ),
                  )
                : _buildAvatarPlaceholder(_report!.clientName),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _report!.clientName,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _getFormatIcon(_report!.sessionFormat),
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getFormatText(_report!.sessionFormat),
                      style: AppTextStyles.body2.copyWith(
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
    );
  }

  Widget _buildReportForm(bool isViewMode) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Тема сеанса',
            controller: _themeController,
            required: true,
            enabled: !isViewMode,
            hint: 'Напр: Работа с тревожностью',
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          _buildFormField(
            label: 'Описание сеанса',
            controller: _descriptionController,
            required: true,
            enabled: !isViewMode,
            hint: 'Подробное описание того, что обсуждалось на сессии...',
            maxLines: 8,
          ),
          const SizedBox(height: 24),
          _buildFormField(
            label: 'Рекомендации клиенту',
            controller: _recommendationsController,
            required: false,
            enabled: !isViewMode,
            hint: 'Рекомендации для клиента (необязательно)',
            maxLines: 5,
          ),
          if (isViewMode && _report!.completedAt != null) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Завершён: ${_report!.formattedCompletedAt}',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required bool required,
    required bool enabled,
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Это поле обязательно для заполнения';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled
                ? AppColors.inputBackground
                : AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.inputBorder.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.inputBorder.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: AppTextStyles.body1,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSaving ? null : _saveDraft,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Text(
                    'Сохранить черновик',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSaving ? null : _completeReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Завершить отчёт', style: AppTextStyles.button),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    final initials = _getInitials(name);
    return Center(
      child: Text(
        initials,
        style: AppTextStyles.body1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Не удалось загрузить отчёт',
            style: AppTextStyles.h3.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onBack,
            child: const Text('Вернуться назад'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppTextStyles.h3),
        content: Text(message, style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Отмена',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Подтвердить', style: AppTextStyles.button),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  IconData _getFormatIcon(String format) {
    switch (format.toUpperCase()) {
      case 'ONLINE':
        return Icons.videocam_outlined;
      case 'OFFLINE':
        return Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }

  String _getFormatText(String format) {
    switch (format.toUpperCase()) {
      case 'ONLINE':
        return 'Онлайн консультация';
      case 'OFFLINE':
        return 'Личная встреча';
      default:
        return format;
    }
  }
}
