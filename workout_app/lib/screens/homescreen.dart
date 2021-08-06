import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:workout_app/Components/homeselectionboxes.dart';
import 'package:workout_app/screens/workouthome.dart';
import '../constants.dart';
import 'diethome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance<SupabaseClient>().auth.user();

    _logout() async {
      await GetIt.I.get<SupabaseClient>().auth.signOut();

      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();

      Navigator.pushReplacementNamed(context, '/');
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: defaultBackgroundColour,
            body: Center(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(),
                      decoration: BoxDecoration(
                        color: AppbarColour,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(1, 1, 1, 0.4),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('assets/logo.png'),
                            ),
                          ),
                        ),
                      ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'User: ${currentUser?.email}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                      HomeSelectionBox(
                        containertext: "Workouts",
                        containerroutename: "/WorkoutHome",
                        containerroutewidget: WorkoutHomeScreen(),
                        containerimageloc: "assets/workouts.jpg",
                        tintcolour: workoutsTintColour,
                      ),
                      HomeSelectionBox(
                        containertext: "Diet",
                        containerroutename: "/DietHome",
                        containerroutewidget: DietHomeScreen(),
                        containerimageloc: "assets/diet.jpg",
                        tintcolour: dietTintColour,
                      ),
                      MaterialButton(
                        color: Colors.grey[800],
                        onPressed: () {
                          _logout();
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: WorkoutsAccentColour,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
