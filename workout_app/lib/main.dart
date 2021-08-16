import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_app/Screens/Main/homescreen.dart';
import 'package:workout_app/Screens/Main/loginscreen.dart';
import 'package:workout_app/Screens/Main/splashscreen.dart';
import 'Screens/Main/usersettingsscreen.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dqimsmzzvoxuefvmtyjd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODkxMzAyMSwiZXhwIjoxOTQ0NDg5MDIxfQ.WW6GLEqWWJJRUR1vAx18Af4sxHlFJivJVvxb6YTBqf0',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      color: defaultBackgroundColour,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/accountsettings': (_) => UserSettings(),
      },
    );
  }
}