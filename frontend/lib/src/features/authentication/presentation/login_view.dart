import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/common_widgets/splash_loading.dart';
import 'package:frontend/src/features/authentication/presentation/login_viewmodel.dart';
import 'package:get_it/get_it.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    required this.viewModel,
  });

  final LoginViewModel viewModel;

  static const routeName = "/logIn";

  static Route<void> getRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          const LoginView(),
    );
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController(text: 'email@example.com');
  final TextEditingController _password = TextEditingController(text: 'password');

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginView oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
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
                  controller: _email,
                ),
              ],
            ),
            const SizedBox(height: 33,),
            Column(
              children: [
                const Text("Password"),
                TextField(
                  controller: _password,
                ),
              ],
            ),
            ElevatedButton(onPressed: () {
              widget.viewModel.login
                .execute((_email.value.text, _password.value.text));
              },
              child: const Text("Login"))
          ],
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      context.go(Routes.home);
    }

    if (widget.viewModel.login.error) {
      widget.viewModel.login.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileLogin),
          action: SnackBarAction(
            label: AppLocalization.of(context).tryAgain,
            onPressed: () => widget.viewModel.login
                .execute((_email.value.text, _password.value.text)),
          ),
        ),
      );
    }
  }
}