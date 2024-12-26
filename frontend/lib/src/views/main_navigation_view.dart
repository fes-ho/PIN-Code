import 'package:flutter/material.dart';
import 'package:frontend/src/features/friendship/presentation/friends_view.dart';
import 'package:frontend/src/views/profile_view.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}