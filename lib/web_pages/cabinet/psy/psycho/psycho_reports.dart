import 'package:flutter/material.dart';
import '../../../../widgets/unified_sidebar.dart';
import '../../../../models/report_model.dart';
import '../../../../core/services/reports_service.dart';
import '../../../../widgets/psychologist/reports/reports_date_list.dart';
import '../../../../widgets/psychologist/reports/reports_list_view.dart';
import '../../../../widgets/psychologist/reports/report_editor_view.dart';

enum ReportViewLevel {
  datesList, // Уровень 1: выбор даты
  reportsList, // Уровень 2: список отчётов за дату
  reportDetail, // Уровень 3: просмотр/редактирование
}

class PsychoReportsPage extends StatefulWidget {
  const PsychoReportsPage({super.key});

  @override
  State<PsychoReportsPage> createState() => _PsychoReportsPageState();
}

class _PsychoReportsPageState extends State<PsychoReportsPage> {
  final ReportsService _service = ReportsService();

  ReportViewLevel _currentLevel = ReportViewLevel.datesList;
  DateTime? _selectedDate;
  int? _selectedReportId;

  List<ReportModel> _allReports = [];
  List<ReportGroupByDate> _reportGroups = [];
  List<ReportModel> _reportsForDate = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final reports = await _service.getMyReports();

      setState(() {
        _allReports = reports;
        _reportGroups = _service.getReportGroups(reports);
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading reports: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Не удалось загрузить отчёты';
      });
    }
  }

  void _navigateToDatesList() {
    setState(() {
      _currentLevel = ReportViewLevel.datesList;
      _selectedDate = null;
      _selectedReportId = null;
    });
  }

  void _navigateToReportsList(DateTime date) {
    final reportsForDate = _allReports.where((report) {
      final reportDate = DateTime(
        report.sessionDate.year,
        report.sessionDate.month,
        report.sessionDate.day,
      );
      return reportDate == date;
    }).toList();

    setState(() {
      _currentLevel = ReportViewLevel.reportsList;
      _selectedDate = date;
      _reportsForDate = reportsForDate;
    });
  }

  void _navigateToReportDetail(int reportId) {
    setState(() {
      _currentLevel = ReportViewLevel.reportDetail;
      _selectedReportId = reportId;
    });
  }

  void _onReportUpdated() {
    // Обновляем список отчётов после изменения
    _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          const UnifiedSidebar(currentRoute: '/psycho/reports'),
          Expanded(child: _buildCurrentView()),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    switch (_currentLevel) {
      case ReportViewLevel.datesList:
        return ReportsDateList(
          reportGroups: _reportGroups,
          onDateSelected: _navigateToReportsList,
        );

      case ReportViewLevel.reportsList:
        return ReportsListView(
          selectedDate: _selectedDate!,
          reports: _reportsForDate,
          onReportSelected: _navigateToReportDetail,
          onBack: _navigateToDatesList,
        );

      case ReportViewLevel.reportDetail:
        return ReportEditorView(
          reportId: _selectedReportId!,
          onBack: () {
            _onReportUpdated();
            _navigateToReportsList(_selectedDate!);
          },
        );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF57A2EB)),
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
            _errorMessage ?? 'Произошла ошибка',
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadReports,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF57A2EB),
            ),
            child: const Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }
}
