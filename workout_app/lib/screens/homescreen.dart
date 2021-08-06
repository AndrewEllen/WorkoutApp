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
    //late final _usernameController = TextEditingController();
    //var _loading = false;

    /*Future<void> _getProfile(String userId) async {
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
        _usernameController.text = response.data!['username'] as String;
      }
      setState(() {
        _loading = false;
      });
    }

    Future<void> _updateProfile() async {
      final userName = _usernameController.text;
      final user = supabase.auth.currentUser;
      final updates = {
        'id': user!.id,
        'username': userName,
        'updated_at': DateTime.now().toIso8601String(),
      };
      final response =
          await supabase.from('profiles').upsert(updates).execute();
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.error!.message),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully updated profile!')));
      }
    }

    @override
    void dispose() {
      _usernameController.dispose();
      super.dispose();
    }*/

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
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "Fitness Tracker",
                        style: TextStyle(
                          fontSize: 50,
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
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Row(children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          width: 200,
                          child: TextFormField(
                            controller: _usernameController,
                            cursorColor: Colors.black,
                            style: TextStyle(),
                            decoration: InputDecoration(
                              labelText: 'Display Name',
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Invalid Username';
                              }
                            },
                          ),
                        ),
                      ]),*/
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
