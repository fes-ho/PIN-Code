import 'package:flutter/material.dart';
import 'package:frontend/src/features/friendship/presentation/friends_view.dart';
import 'package:frontend/src/views/profile2.dart';
import 'package:frontend/src/views/statistics_view.dart';
import 'package:frontend/src/views/today_view/today_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  static const String routeName = "/MainNavigationView";

  static Route<void> getRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          const MainNavigationView(),
    );
  }

  @override
  MainNavigationViewState createState() => MainNavigationViewState();
}

class MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TodayView(),
    FriendsView(), 
    StatisticsView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(18),
            bottom : Radius.circular(18)),
          child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'Today',
            activeIcon: const Icon(Icons.home_rounded),
            backgroundColor: colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline_rounded),
            label: 'Social',
            activeIcon: const Icon(Icons.people),
            backgroundColor: colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today_outlined),
            label: 'Stats',
            activeIcon: const Icon(Icons.calendar_today),
            backgroundColor: colorScheme.secondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: const Icon(Icons.person),
            backgroundColor: colorScheme.secondary,
          ),
        ],
        currentIndex: _selectedIndex,
        iconSize: 27,
        selectedFontSize: 0.0, 
        unselectedFontSize: 0.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: colorScheme.onSecondary,
        unselectedItemColor: colorScheme.onSecondary,
        onTap: _onItemTapped,
      ),
        )
      )
    );
  }
}