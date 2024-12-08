import 'package:flutter/material.dart';
import 'package:myapp/widget/news_tile.dart';
import 'package:myapp/services/api_service.dart';

// Category screen where you display categories
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService apiService = ApiService();
  late Future<List<String>> categories; // Future for category list

  @override
  void initState() {
    super.initState();
    categories =
        apiService.fetchCategories(); // Fetch categories on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: FutureBuilder<List<String>>(
        future: categories, // Fetch categories from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching categories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available'));
          } else {
            final categories = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryArticlesScreen(category: categories[index]),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100], // Light newspaper color
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                        border: Border.all(
                            color: Colors.black12,
                            width: 1), // Light border for effect
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getCategoryIcon(categories[index]),
                            color: _getCategoryIconColor(categories[index]),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to return an icon based on the category name
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports_baseball;
      case 'health':
        return Icons.health_and_safety;
      case 'technology':
        return Icons.computer;
      case 'business':
        return Icons.business;
      case 'entertainment':
        return Icons.movie;
      case 'science':
        return Icons.science;
      case 'politics':
        return Icons.public;
      default:
        return Icons.category;
    }
  }

  //  a color for the category icon
  Color _getCategoryIconColor(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Colors.green;
      case 'health':
        return Colors.red;
      case 'technology':
        return Colors.blue;
      case 'business':
        return Colors.orange;
      case 'entertainment':
        return Colors.purple;
      case 'science':
        return Colors.cyan;
      case 'politics':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }
}

// Category Articles screen where you show articles of a selected category
class CategoryArticlesScreen extends StatelessWidget {
  final String category;
  final ApiService apiService = ApiService();

  CategoryArticlesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: FutureBuilder(
        future: apiService.fetchCategoryArticles(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching articles'));
          } else {
            final articles = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the full article screen on tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullNewsScreen(
                          article: articles[index],
                        ),
                      ),
                    );
                  },
                  child: NewsTile(
                    title: articles[index]['title'] ?? '',
                    description: articles[index]['description'] ?? '',
                    imageUrl: articles[index]['urlToImage'] ?? '',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Full news screen where you display the full news article
class FullNewsScreen extends StatelessWidget {
  final dynamic article; // The article data passed from CategoryArticlesScreen

  const FullNewsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'] ?? '')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              Image.network(article['urlToImage']),
            const SizedBox(height: 16.0),
            Text(
              article['title'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              article['publishedAt'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Text(
              article['content'] ?? 'No content available',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
