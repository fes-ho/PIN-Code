import 'package:flutter/material.dart';
import 'package:frontend/src/exceptions/not_logged_in_member_exception.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/authentication/presentation/log_in_view.dart';
import 'package:frontend/src/views/main_navigation_view.dart';
import 'package:get_it/get_it.dart';

class SplashLoading extends StatefulWidget {
  const SplashLoading({super.key});

  static const String routeName = "/splashLoadingView";

  @override
  _SplashLoading createState() => _SplashLoading();
}

class _SplashLoading extends State<SplashLoading> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    try {
      await GetIt.I<MemberService>().getMember();

      Navigator.restorablePushAndRemoveUntil(
        context,
        (context, __) => MaterialPageRoute(builder: (context) => const MainNavigationView()),
        (_) => false
      );      
    }
    on NotLoggedInMemberException catch (_) {
      Navigator.restorablePushAndRemoveUntil(
        context,
        LogIn.getRouteBuilder,
        (_) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}