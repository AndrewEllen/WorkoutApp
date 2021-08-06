import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  void checkLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final session = sharedPreferences.getString('user');

    if (session == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      final response =
      await GetIt.instance<SupabaseClient>().auth.recoverSession(session);

      sharedPreferences.setString('user', response.data!.persistSessionString);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}