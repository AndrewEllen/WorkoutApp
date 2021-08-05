import 'package:flutter/material.dart';
import 'package:workout_app/components/auth_state.dart';
import '../constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends AuthState<SplashPage> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: defaultBackgroundColour,
      body: Center(
          child: CircularProgressIndicator(),
          )
    );
  }
}