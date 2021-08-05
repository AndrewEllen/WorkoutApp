import 'package:flutter/material.dart';
import 'package:workout_app/screens/index.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/Home': (BuildContext context) => HomeScreen(),
    '/WorkoutHome': (BuildContext context) => WorkoutHomeScreen(),
    '/DietHome': (BuildContext context) => DietHomeScreen(),
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
        home: new HomeScreen(),
      )
    );
  }

}