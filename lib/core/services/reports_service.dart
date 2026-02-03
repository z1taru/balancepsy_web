import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/config/api_config.dart';
import '../../../../../../core/storage/token_storage.dart';
import '../../../../../../models/report_model.dart';

class ReportsService {
  final TokenStorage _storage = TokenStorage();

  /// Получить все отчёты психолога
  Future<List<ReportModel>> getMyReports() async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('Не авторизован');

      print('📡 Fetching reports from: ${ApiConfig.myReports}');

      final response = await http
          .get(
            Uri.parse(ApiConfig.myReports),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> reportsJson = data['data'];
          final reports = reportsJson
              .map((json) => ReportModel.fromJson(json))
              .toList();

          print('✅ Loaded ${reports.length} report(s)');
          return reports;
        }
      }

      throw Exception('Не удалось загрузить отчёты');
    } catch (e) {
      print('❌ Error loading reports: $e');
      rethrow;
    }
  }

  /// Получить незавершённые отчёты
  Future<List<ReportModel>> getIncompleteReports() async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('Не авторизован');

      print('📡 Fetching incomplete reports');

      final response = await http
          .get(
            Uri.parse(ApiConfig.incompleteReports),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> reportsJson = data['data'];
          return reportsJson.map((json) => ReportModel.fromJson(json)).toList();
        }
      }

      return [];
    } catch (e) {
      print('❌ Error loading incomplete reports: $e');
      return [];
    }
  }

  /// Получить отчёт по ID
  Future<ReportModel> getReportById(int id) async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('Не авторизован');

      final url = ApiConfig.reportById(id);
      print('📡 Fetching report: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headersWithAuth(token))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          print('✅ Report loaded');
          return ReportModel.fromJson(data['data']);
        }
      }

      throw Exception('Отчёт не найден');
    } catch (e) {
      print('❌ Error loading report: $e');
      rethrow;
    }
  }

  /// Обновить отчёт
  Future<ReportModel> updateReport(
    int id, {
    String? sessionTheme,
    String? sessionDescription,
    String? recommendations,
    bool? isCompleted,
  }) async {
    try {
      final token = await _storage.getToken();
      if (token == null) throw Exception('Не авторизован');

      final body = <String, dynamic>{};
      if (sessionTheme != null) body['sessionTheme'] = sessionTheme;
      if (sessionDescription != null) {
        body['sessionDescription'] = sessionDescription;
      }
      if (recommendations != null) body['recommendations'] = recommendations;
      if (isCompleted != null) body['isCompleted'] = isCompleted;

      print('📡 Updating report $id: $body');

      final response = await http
          .put(
            Uri.parse(ApiConfig.reportById(id)),
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode(body),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          print('✅ Report updated successfully');
          return ReportModel.fromJson(data['data']);
        }
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Не удалось обновить отчёт');
    } catch (e) {
      print('❌ Error updating report: $e');
      rethrow;
    }
  }

  /// Группировка отчётов по датам
  Map<DateTime, List<ReportModel>> groupReportsByDate(
    List<ReportModel> reports,
  ) {
    final Map<DateTime, List<ReportModel>> grouped = {};

    for (var report in reports) {
      final dateKey = DateTime(
        report.sessionDate.year,
        report.sessionDate.month,
        report.sessionDate.day,
      );

      grouped.putIfAbsent(dateKey, () => []).add(report);
    }

    return grouped;
  }

  /// Преобразование в список групп для UI
  List<ReportGroupByDate> getReportGroups(List<ReportModel> reports) {
    final grouped = groupReportsByDate(reports);

    final groups = grouped.entries.map((entry) {
      return ReportGroupByDate(date: entry.key, reports: entry.value);
    }).toList();

    // Сортируем по дате (новые первыми)
    groups.sort((a, b) => b.date.compareTo(a.date));

    return groups;
  }
}
