import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar.dart';
import 'package:workout_app/Components/sidebar.dart';
import 'dart:async';
import 'package:supabase/supabase.dart';
import '../constants.dart';

class DietHomeScreen extends StatefulWidget {
  @override
  _DietHomeScreenState createState() => _DietHomeScreenState();
}

class _DietHomeScreenState extends State<DietHomeScreen> {
  final currentUser = supabase.auth.user();
  var _loading = false;
  var calories;

  void initState() {
    _getProfile(currentUser!.id);
  }

  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      calories = response.data!['daily_calories'];
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: DietAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: "Diet",
        ),
        drawer: CustomSideBar(
          sidebaraccentcolour: DietAccentColour,
          sidebarcolour: SideBarColour,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(bottom:150),
            child: Text(
              'Daily Calories Goal: ${calories.toString()}',
              style: TextStyle(
                color: Colors.white,

              ),
            ),
          ),
        )
      ),
    );
  }
}
