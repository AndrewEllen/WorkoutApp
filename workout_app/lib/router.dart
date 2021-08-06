import 'package:flutter/material.dart';
import 'package:workout_app/screens/index.dart';

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


class Routes {
  final routes = <String, WidgetBuilder>{
    '/Home': (BuildContext context) => HomeScreen2(),
  };

  Routes() {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workout App',
        routes: routes,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: HomeScreen2(),
      )
    );
  }

}