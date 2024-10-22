import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  static const String routeName = "/mainView";

  static Route<void> getRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          const MainView(),
    );
  } 

  @override
  Widget build(BuildContext context) {
    return const Text("Authenticated route");
  }
}