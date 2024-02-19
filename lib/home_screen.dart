import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sansadtv_app/constants.dart';
import 'package:sansadtv_app/explore_screen.dart';
import 'package:sansadtv_app/offline_screen.dart';
import 'package:sansadtv_app/recent_screen.dart';
import 'package:sansadtv_app/search_screen.dart';
import 'package:sansadtv_app/web_content_handler.dart';
import 'package:universal_html/html.dart' as html;

class STVHomeScreen extends StatefulWidget {
  const STVHomeScreen({super.key});

  @override
  State<STVHomeScreen> createState() => _STVHomeScreenState();
}

class _STVHomeScreenState extends State<STVHomeScreen> {
  int currentPage = 0;
  bool networkConnected = false;
  late html.HtmlDocument document;
  List<Widget> pages = [
    const RecentScreen(),
    const SearchScreen(),
  ];

  @override
  void initState() {
    super.initState();
    networkApp();
  }

  Future<void> networkApp() async {
    try {
      document = await fetchHTML(webUrl).timeout(const Duration(seconds: 20));
      setState(() {
        networkConnected = true;
        pages.add(ExploreScreen(doc: document));
      });
    } catch (e) {
      networkConnected = false;
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return networkConnected
        ? Scaffold(
            body: IndexedStack(
              index: currentPage,
              children: pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 35,
              onTap: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              currentIndex: currentPage,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_rounded),
                  label: 'Explore',
                ),
              ],
            ),
          )
        : const OfflineScreen();
  }
}
