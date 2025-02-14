import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infotune/blocs/dictionary_bloc.dart';
import 'package:infotune/screens/dictionary_screen/dictionary_screen.dart';
import 'package:infotune/screens/music_screen/music_screen.dart';
import 'package:infotune/screens/news_screen/news_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late DictionaryBloc dictionaryBloc;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    dictionaryBloc = DictionaryBloc();
  }

  @override
  void dispose() {
    dictionaryBloc.close(); // Dispose of the bloc
    super.dispose();
  }

  final List<Widget> _screens = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screens.addAll([
      const NewsScreen(),
      DictionaryScreen(dictionaryBloc: dictionaryBloc), // Fixed typo here
      const MusicScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DictionaryBloc>(create: (context) => dictionaryBloc),
      ],
      child: Scaffold(
        body: _screens[_currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue.shade400,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
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
      ),
    );
  }
}
