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
  late final username;
  final currentUser = supabase.auth.user();
  var _loading = false;

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
      username = response.data!['username'] as String;
    } else {
      username = currentUser?.email;
    }
    setState(() {
      _loading = false;
    });
  }

  _logout() async {
    await supabase.auth.signOut();

    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void onUnauthenticated() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
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
                        'User: ${_loading ? currentUser?.email : username}',
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


                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom:50),
                      child: MaterialButton(
                        color: Colors.black,
                        onPressed: () {
                          _logout();
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: WorkoutsAccentColour,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
