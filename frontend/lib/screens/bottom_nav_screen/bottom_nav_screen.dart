import 'package:flutter/material.dart';
import 'package:infotune/screens/dictionary_screen/dictionary_screen.dart';
import 'package:infotune/screens/music_screen/music_screen.dart';
import 'package:infotune/screens/news_screen/news_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _screens = [
    const NewsScreen(),
    const DictionaryScreen(),
    const MusicScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentPageIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index; // Update the current index on tap
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
        ],
      ),
    );
  }
}
