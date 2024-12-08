// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String newsApiKey = '741061c94cdb453697135630f5b34059';
  bool isLoading = true;
  List<dynamic>? weatherNewsArticles;

  @override
  void initState() {
    super.initState();
    fetchWeatherNews();
  }

  // Fetch weather-related news articles
  Future<void> fetchWeatherNews() async {
    final newsUrl =
        'https://newsapi.org/v2/everything?q=weather&apiKey=$newsApiKey';

    try {
      final newsResponse = await http.get(Uri.parse(newsUrl));
      if (newsResponse.statusCode == 200) {
        setState(() {
          weatherNewsArticles = json.decode(newsResponse.body)['articles'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather News'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weatherNewsArticles == null
              ? const Center(child: Text('Failed to load data.'))
              : ListView.builder(
                  itemCount: weatherNewsArticles!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        weatherNewsArticles![index]['urlToImage'] ??
                            'https://via.placeholder.com/150',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(weatherNewsArticles![index]['title']),
                      subtitle: Text(
                        weatherNewsArticles![index]['description'] ??
                            'No description',
                      ),
                      onTap: () {
                        // Optionally, navigate to a detailed news article view
                      },
                    );
                  },
                ),
    );
  }
}
