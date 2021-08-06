import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance<SupabaseClient>().auth.user();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hi ${currentUser?.email}'),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  _logout();
                },
                child: Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _logout() async {
    await GetIt.I.get<SupabaseClient>().auth.signOut();

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.pushReplacementNamed(context, '/');
  }
}