import 'package:flutter/material.dart';
import 'package:myapp/controls/controls.dart';

class TitleScreen extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  // Constructor to receive the theme state and toggle function
  const TitleScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image (GIF or any image you want)
          Positioned.fill(
            child: Image.asset(
              'assets/newsbg.gif', // Replace with the path to your image or GIF
              fit: BoxFit.cover,
            ),
          ),

          // Center the "Get Started" button at the bottom of the screen
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                onPressed: () {
                  // Navigate to MenuScreen, passing the theme state and toggle function
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuScreen(
                        isDarkMode: isDarkMode, // Pass the current theme state
                        toggleTheme:
                            toggleTheme, // Pass the theme toggle function
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Get Started', // Button text
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Button text color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
