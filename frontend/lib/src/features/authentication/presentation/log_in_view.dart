import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/common_widgets/splash_loading.dart';
import 'package:get_it/get_it.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  static const routeName = "/logIn";

  static Route<void> getRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          const LogIn(),
    );
  }

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text("Email"),
                TextField(
                  controller: _emailEditingController,
                ),
              ],
            ),
            const SizedBox(height: 33,),
            Column(
              children: [
                const Text("Password"),
                TextField(
                  controller: _passwordEditingController,
                ),
              ],
            ),
            ElevatedButton(onPressed: () {
              GetIt.I<MemberService>().signIn(
                _emailEditingController.text,
                _passwordEditingController.text
              ).then((_) => Navigator.pushNamed(context, SplashLoading.routeName));
            }, child: const Text("Sign In"))
          ],
        ),
      ),
    );
  }
}