// lib/core/services/article_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ArticleApiService {
  final TokenStorage _storage = TokenStorage();

  /// Получить список статей с фильтрацией и пагинацией
  Future<Map<String, dynamic>> getArticles({
    String? category,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await _storage.getToken();

      String url = '${ApiConfig.articles}?page=$page&size=$size';
      if (category != null && category.isNotEmpty) {
        url += '&category=$category';
      }

      print('📡 Fetching articles from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: token != null
                ? ApiConfig.headersWithAuth(token)
                : ApiConfig.headers,
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Articles loaded successfully');
        return data;
      }

      throw Exception('Failed to load articles: ${response.statusCode}');
    } catch (e) {
      print('❌ Error loading articles: $e');
      rethrow;
    }
  }

  /// Получить статью по slug
  Future<Map<String, dynamic>> getArticleBySlug(String slug) async {
    try {
      final token = await _storage.getToken();

      final url = ApiConfig.articleBySlug(slug);
      print('📡 Fetching article from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: token != null
                ? ApiConfig.headersWithAuth(token)
                : ApiConfig.headers,
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Article loaded successfully');
        return data;
      }

      if (response.statusCode == 404) {
        throw Exception('Article not found');
      }

      throw Exception('Failed to load article: ${response.statusCode}');
    } catch (e) {
      print('❌ Error loading article: $e');
      rethrow;
    }
  }

  /// Поиск статей
  Future<Map<String, dynamic>> searchArticles({
    required String query,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await _storage.getToken();

      final url =
          '${ApiConfig.articles}/search?query=$query&page=$page&size=$size';
      print('📡 Searching articles: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: token != null
                ? ApiConfig.headersWithAuth(token)
                : ApiConfig.headers,
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Search completed successfully');
        return data;
      }

      throw Exception('Search failed: ${response.statusCode}');
    } catch (e) {
      print('❌ Error searching articles: $e');
      rethrow;
    }
  }

  /// Получить топ статей
  Future<Map<String, dynamic>> getTopArticles({int limit = 10}) async {
    try {
      final token = await _storage.getToken();

      final url = '${ApiConfig.articles}/top?limit=$limit';
      print('📡 Fetching top articles from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: token != null
                ? ApiConfig.headersWithAuth(token)
                : ApiConfig.headers,
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Top articles loaded successfully');
        return data;
      }

      throw Exception('Failed to load top articles: ${response.statusCode}');
    } catch (e) {
      print('❌ Error loading top articles: $e');
      rethrow;
    }
  }

  /// Добавить статью в избранное
  Future<bool> addToFavorites(int articleId) async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        print('⚠️ User not authenticated');
        return false;
      }

      final url = '${ApiConfig.articles}/$articleId/favorite';
      print('📡 Adding to favorites: $url');

      final response = await http
          .post(Uri.parse(url), headers: ApiConfig.headersWithAuth(token))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final success = data['success'] == true;
        print(success ? '✅ Added to favorites' : '⚠️ Already in favorites');
        return success;
      }

      print('❌ Failed to add to favorites: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error adding to favorites: $e');
      return false;
    }
  }

  /// Удалить статью из избранного
  Future<bool> removeFromFavorites(int articleId) async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        print('⚠️ User not authenticated');
        return false;
      }

      final url = '${ApiConfig.articles}/$articleId/favorite';
      print('📡 Removing from favorites: $url');

      final response = await http
          .delete(Uri.parse(url), headers: ApiConfig.headersWithAuth(token))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        print('✅ Removed from favorites');
        return true;
      }

      print('❌ Failed to remove from favorites: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error removing from favorites: $e');
      return false;
    }
  }

  /// Получить избранные статьи
  Future<Map<String, dynamic>> getFavorites({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final url = '${ApiConfig.articles}/favorites?page=$page&size=$size';
      print('📡 Fetching favorites from: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headersWithAuth(token))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Favorites loaded successfully');
        return data;
      }

      throw Exception('Failed to load favorites: ${response.statusCode}');
    } catch (e) {
      print('❌ Error loading favorites: $e');
      rethrow;
    }
  }

  /// Проверить, находится ли статья в избранном
  Future<bool> isFavorite(int articleId) async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        return false;
      }

      final url = '${ApiConfig.articles}/$articleId/is-favorite';
      print('📡 Checking favorite status: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headersWithAuth(token))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final isFav = data['data'] == true;
        print('✅ Is favorite: $isFav');
        return isFav;
      }

      return false;
    } catch (e) {
      print('❌ Error checking favorite status: $e');
      return false;
    }
  }

  /// Переключить статус избранного (add/remove)
  Future<bool> toggleFavorite(int articleId, bool currentStatus) async {
    if (currentStatus) {
      return await removeFromFavorites(articleId);
    } else {
      return await addToFavorites(articleId);
    }
  }
}
