import 'package:flutter/material.dart';
import 'package:workout_app/screens/index.dart';
import 'package:workout_app/screens/account_page.dart';
import 'package:workout_app/screens/login_page.dart';
import 'package:workout_app/screens/splash_page.dart';
import 'constants.dart';

class FadeRouter extends PageRouteBuilder {
  final Widget screen;

  FadeRouter({required this.screen, required String routeName})
      : super(
    settings: RouteSettings(name: routeName),
    pageBuilder: (
        BuildContext context,
        Animation<double> firstAnimation,
        Animation<double> secondAnimation,
        ) =>
    screen,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> firstAnimation,
        Animation<double> secondAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: firstAnimation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 200),
  );
}


class Routes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        accentColor: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/Home': (_) => HomeScreen(),
      },
    );
  }
}