import 'package:flutter/material.dart';
import 'package:frontend/src/services/exceptions/not_logged_in_member_exception.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:frontend/src/views/log_in_view.dart';
import 'package:frontend/src/views/main_view.dart';
import 'package:get_it/get_it.dart';

class SplashLoadingView extends StatefulWidget {
  const SplashLoadingView({super.key});

  static const String routeName = "/splashLoadingView";

  @override
  _SplashLoadingView createState() => _SplashLoadingView();
}

class _SplashLoadingView extends State<SplashLoadingView> {
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
        MainView.getRouteBuilder,
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