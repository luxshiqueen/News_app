import 'package:flutter/material.dart';
import 'package:myapp/widget/news_tile.dart';
import 'package:myapp/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> _searchResults = [];

  void _performSearch() async {
    final results = await apiService.searchArticles(_controller.text);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Search news...'),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return NewsTile(
                  title: _searchResults[index]['title'] ?? '',
                  description: _searchResults[index]['description'] ?? '',
                  imageUrl: _searchResults[index]['urlToImage'] ?? '',
                );
              },
            ),
    );
  }
}
