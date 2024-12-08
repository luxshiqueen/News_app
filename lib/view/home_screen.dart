import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/view/title_screen.dart';
import 'package:myapp/widget/NewsDetailScreen.dart';
import 'package:myapp/widget/news_tile.dart';
import 'package:myapp/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  String _sortOption = 'Title'; // Default sorting option
  String _dateSortOption = 'Latest'; // Default date sort option

  // Example toggleTheme function
  void toggleTheme() {
    setState(() {
      // Your logic to toggle theme, this can change the theme in your app
    });
  }

  // Sort articles based on selected option
  List<dynamic> sortArticles(List<dynamic> articles) {
    if (_sortOption == 'Title') {
      articles.sort((a, b) => a['title'].compareTo(b['title']));
    } else if (_sortOption == 'Date') {
      if (_dateSortOption == 'Latest') {
        articles.sort((a, b) => b['publishedAt'].compareTo(a['publishedAt']));
      } else if (_dateSortOption == 'Oldest') {
        articles.sort((a, b) => a['publishedAt'].compareTo(b['publishedAt']));
      }
    }
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TitleScreen(
                      toggleTheme: toggleTheme,
                      isDarkMode: false, // Adjust as needed
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text('Top News'),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            onChanged: (String? newValue) {
              setState(() {
                _sortOption = newValue!;
                if (_sortOption == 'Date') {
                  _dateSortOption = 'Latest';
                }
              });
            },
            items: <String>['Title', 'Date']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (_sortOption == 'Date')
            DropdownButton<String>(
              value: _dateSortOption,
              onChanged: (String? newValue) {
                setState(() {
                  _dateSortOption = newValue!;
                });
              },
              items: <String>['Latest', 'Oldest']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
        ],
      ),
      body: FutureBuilder(
        future: apiService.fetchTopHeadlines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching news'));
          } else {
            final articles = snapshot.data as List<dynamic>;
            final sortedArticles = sortArticles(articles);

            return Column(
              children: [
                // News Title Carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: 120.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: sortedArticles.map((article) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewsDetailScreen(
                                  title: article['title'] ?? '',
                                  content: article['content'] ?? '',
                                  imageUrl: article['urlToImage'] ?? '',
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            color: Colors.blue.shade100, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  article['title'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent, // Text color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Expanded(
                  // News Articles List
                  child: ListView.builder(
                    itemCount: sortedArticles.length,
                    itemBuilder: (context, index) {
                      final article = sortedArticles[index];
                      final title = article['title'] ?? '';
                      final description = article['description'] ?? '';
                      final imageUrl = article['urlToImage'] ?? '';
                      final content = article['content'] ?? '';

                      return NewsTile(
                        title: title,
                        description: description,
                        imageUrl: imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(
                                title: title,
                                content: content,
                                imageUrl: imageUrl,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
