import 'package:flutter/material.dart';
import 'package:myapp/view/title_screen.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  bool _isDarkMode = false;

  // Function to toggle dark mode
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Toggle the theme state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Light theme settings
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Dark theme settings
      ),
      themeMode: _isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light, // Set theme based on _isDarkMode
      home: TitleScreen(
        toggleTheme:
            _toggleTheme, // Pass the theme toggle function to TitleScreen
        isDarkMode: _isDarkMode, // Pass the theme state to TitleScreen
      ),
    );
  }
}
