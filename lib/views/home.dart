import 'package:contest_flow/views/home/appbar.dart';
import 'package:contest_flow/views/home/contest.dart';
import 'package:contest_flow/views/home/navigation.dart';
import 'package:contest_flow/views/home/settings.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(() {
      final pageIndex = _pageController.page?.round() ?? 0;
      if (pageIndex != _currentPage) {
        setState(() {
          _currentPage = pageIndex;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: PageView(
          controller: _pageController,
          children: const [
            ContestView(),
            SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationView(pageController: _pageController),
    );
  }
}
