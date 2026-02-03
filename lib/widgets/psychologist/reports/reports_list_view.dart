import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../models/report_model.dart';

class ReportsListView extends StatelessWidget {
  final DateTime selectedDate;
  final List<ReportModel> reports;
  final Function(int) onReportSelected;
  final VoidCallback onBack;

  const ReportsListView({
    super.key,
    required this.selectedDate,
    required this.reports,
    required this.onReportSelected,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumbs(),
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 32),
          _buildReportsList(),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          child: Row(
            children: [
              const Icon(Icons.arrow_back, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Все даты',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          _formatDate(selectedDate),
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(selectedDate),
              style: AppTextStyles.h1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              '${reports.length} ${_getSessionWord(reports.length)}',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsList() {
    if (reports.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: reports.map((report) => _buildReportItem(report)).toList(),
      ),
    );
  }

  Widget _buildReportItem(ReportModel report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onReportSelected(report.id),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inputBorder.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                // Аватар клиента
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: report.clientAvatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            report.clientAvatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildAvatarPlaceholder(report.clientName);
                            },
                          ),
                        )
                      : _buildAvatarPlaceholder(report.clientName),
                ),
                const SizedBox(width: 16),
                // Информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              report.clientName,
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildStatusBadge(report.status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Тема: ${report.sessionTheme}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getFormatIcon(report.sessionFormat),
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getFormatText(report.sessionFormat),
                            style: AppTextStyles.body3.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Стрелка
                Icon(
                  report.isCompleted
                      ? Icons.visibility_outlined
                      : Icons.edit_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
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
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ReportStatus status) {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case ReportStatus.completed:
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = 'Готов';
        icon = Icons.check_circle;
        break;
      case ReportStatus.draft:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = 'Черновик';
        icon = Icons.edit;
        break;
      case ReportStatus.pending:
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        text = 'Требуется';
        icon = Icons.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body3.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Нет отчётов за эту дату',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
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

    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _getSessionWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'сессия';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'сессии';
    } else {
      return 'сессий';
    }
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
        return 'Онлайн';
      case 'OFFLINE':
        return 'Офлайн';
      default:
        return format;
    }
  }
}
