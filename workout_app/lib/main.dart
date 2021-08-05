import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/router.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    url: 'https://lcjngwublvbgavlkrtse.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODE5OTY2MiwiZXhwIjoxOTQzNzc1NjYyfQ.cSD7H0cN4F3HQoGJZowu1DEu5it3BmqTdelqHiiWNI8',
    authCallbackUrlHostname: 'login-callback',
  );
  runApp(Routes());
}

