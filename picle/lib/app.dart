import 'package:flutter/material.dart';
import 'package:picle/screens/main_screen.dart';
import 'package:picle/screens/challenge_screen.dart';
import 'package:picle/screens/social_screen.dart';
import 'package:picle/screens/my_page_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const MainScreen(),
    const ChallengeScreen(),
    const SocialScreen(),
    const MyPageScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  ColorFilter _getColorFilter(int index) {
    return _currentIndex == index
        ? const ColorFilter.mode(Color(0xFF54C29B), BlendMode.srcIn)
        : const ColorFilter.mode(Color(0XFFC8C8C8), BlendMode.srcIn);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'lib/images/picle_logo.png',
            scale: 2,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF54C29B),
          unselectedItemColor: const Color(0XFFC8C8C8),
          items: [
            BottomNavigationBarItem(
              icon: _buildSvgIcon('lib/icons/home.svg', 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('lib/icons/challenge.svg', 1),
              label: 'Challenge',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('lib/icons/social.svg', 2),
              label: 'Social',
            ),
            BottomNavigationBarItem(
              icon: _buildSvgIcon('lib/icons/mypage.svg', 3),
              label: 'My page',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String svgPath, int index) {
    return ColorFiltered(
      colorFilter: _getColorFilter(index),
      child: SvgPicture.asset(
        svgPath,
        height: 26,
        width: 26,
      ),
    );
  }
}
