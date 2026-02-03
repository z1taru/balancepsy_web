import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_text_styles.dart';
import '../../../../../models/report_model.dart';

class ReportsDateList extends StatelessWidget {
  final List<ReportGroupByDate> reportGroups;
  final Function(DateTime) onDateSelected;

  const ReportsDateList({
    super.key,
    required this.reportGroups,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildStatsCards(),
          const SizedBox(height: 32),
          _buildDatesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Мои отчёты', style: AppTextStyles.h1.copyWith(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          'Выберите дату для просмотра отчётов',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final totalReports = reportGroups.fold<int>(
      0,
      (sum, group) => sum + group.sessionCount,
    );

    final totalClients = reportGroups
        .expand((group) => group.reports)
        .map((r) => r.clientId)
        .toSet()
        .length;

    final completedReports = reportGroups
        .expand((group) => group.reports)
        .where((r) => r.isCompleted)
        .length;

    final pendingReports = reportGroups
        .expand((group) => group.reports)
        .where((r) => !r.isCompleted)
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            totalReports.toString(),
            'всего отчётов',
            Icons.assessment,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            totalClients.toString(),
            'клиентов',
            Icons.people,
            Colors.green,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            completedReports.toString(),
            'завершено',
            Icons.check_circle,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            pendingReports.toString(),
            'в работе',
            Icons.pending,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesList() {
    if (reportGroups.isEmpty) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Отчёты по датам',
            style: AppTextStyles.h2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 24),
          ...reportGroups.map((group) => _buildDateItem(group)),
        ],
      ),
    );
  }

  Widget _buildDateItem(ReportGroupByDate group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onDateSelected(group.date),
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
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      group.date.day.toString(),
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.formattedDate,
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${group.clientCount} ${_getClientWord(group.clientCount)} • ${group.sessionCount} ${_getSessionWord(group.sessionCount)}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
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
              'Отчётов пока нет',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Отчёты появятся после завершения сессий',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getClientWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'клиент';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'клиента';
    } else {
      return 'клиентов';
    }
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
}
