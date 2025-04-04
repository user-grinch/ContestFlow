import 'package:contest_flow/extentions/theme.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NavigationView extends StatefulWidget {
  final PageController pageController;

  const NavigationView({super.key, required this.pageController});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    widget.pageController.addListener(() {
      setState(() {
        _selectedIndex = widget.pageController.page?.round() ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: context.colorScheme.surface,
      elevation: 3,
      indicatorColor: context.colorScheme.secondaryContainer,
      surfaceTintColor: context.colorScheme.surfaceTint,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: Icon(HugeIcons.strokeRoundedAnalytics01),
          label: 'Contests',
        ),
        NavigationDestination(
          icon: Icon(HugeIcons.strokeRoundedSettings03),
          label: 'Settings',
        ),
      ],
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      },
      selectedIndex: _selectedIndex,
    );
  }
}
