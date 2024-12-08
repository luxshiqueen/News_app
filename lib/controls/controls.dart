// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/view/home_screen.dart';
import 'package:myapp/view/search_screen.dart';
import 'package:myapp/view/category_screen.dart';
import 'package:myapp/view/bookmark_screen.dart';
import 'package:myapp/view/weather_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MenuScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const MenuScreen(
      {super.key, required this.isDarkMode, required this.toggleTheme});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    CategoryScreen(),
    BookmarkScreen(),
    WeatherScreen(),
  ];

  final List<Color> _iconColors = [
    Colors.blue, // Home icon color
    Colors.green, // Search icon color
    Colors.orange, // Category icon color
    Colors.purple, // Bookmark icon color
    Colors.yellow, // Weather icon color
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: List.generate(5, (index) {
          return Icon(
            _getIconForIndex(index),
            size: 30,
            color: _iconColors[index],
          );
        }),
        color: const Color.fromARGB(255, 221, 49, 147),
        backgroundColor: const Color.fromARGB(191, 186, 243, 232),
        buttonBackgroundColor: const Color.fromARGB(255, 239, 231, 164),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.toggleTheme();
        },
        child: const Icon(Icons.brightness_6),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.search;
      case 2:
        return Icons.category;
      case 3:
        return Icons.bookmark;
      case 4:
        return Icons.wb_sunny;
      default:
        return Icons.home;
    }
  }
}
