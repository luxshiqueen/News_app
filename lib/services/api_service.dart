import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://newsapi.org/v2';
  final String apiKey = '741061c94cdb453697135630f5b34059';

  // Fetch categories (source categories in this case)
  Future<List<String>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$baseUrl/sources?apiKey=$apiKey'));
    if (response.statusCode == 200) {
      // Parse the source response and extract the categories
      final sources = json.decode(response.body)['sources'] as List<dynamic>;
      return sources
          .map((source) => source['category'] as String)
          .toSet()
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch top headlines
  Future<List<dynamic>> fetchTopHeadlines() async {
    final response = await http
        .get(Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to load headlines');
    }
  }

  // Search articles
  Future<List<dynamic>> searchArticles(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to search articles');
    }
  }

  // Fetch category articles
  Future<List<dynamic>> fetchCategoryArticles(String category) async {
    final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?category=$category&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to fetch category articles');
    }
  }
}
