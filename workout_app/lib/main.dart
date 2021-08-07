import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';
import 'package:workout_app/screens/homescreen.dart';
import 'package:workout_app/screens/loginscreen.dart';
import 'package:workout_app/screens/registerscreen.dart';
import 'package:workout_app/screens/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
      url: 'https://lwoqduelpcooopxiryqc.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODIwOTE5MywiZXhwIjoxOTQzNzg1MTkzfQ.UAhcH6uqOMirAUSX5Z_AfS8W8fBttfrlOooJwI-fnoo',
      authCallbackUrlHostname: 'login-callback',
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}