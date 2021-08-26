import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/Components/Containers/HomeAppBar.dart';
import 'package:workout_app/Components/Screens/homeselectionboxes.dart';
import 'package:workout_app/Screens/Main/usersettingsscreen.dart';
import 'package:workout_app/Screens/Workouts/workouthome.dart';
import '../../constants.dart';
import '../../router.dart';
import '../Diet/diethome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final username, avatar;
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
      avatar = response.data!['avatar_url'] as String;
    } else {
      avatar = "https://i.imgur.com/yKV9vpH.png";
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
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(200),
              child: ClipPath(
                clipper: HomeAppBar(),
                child: Center(
                  child: Container(
                    color: AppbarColour,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  FadeRouter(
                                    routeName: '/usersettings',
                                    screen: UserSettings(),
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 30),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(45),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(_loading
                                      ? 'https://i.imgur.com/yKV9vpH.png'
                                      : avatar),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(right: 0, top: 20),
                            child: Text(
                              'User: ${_loading ? currentUser?.email : username}',
                              style: TextStyle(
                                fontSize: 13,
                                color: WorkoutsAccentColour,
                                shadows: [
                                  Shadow(
                                    blurRadius: 1,
                                    color: Colors.black,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HomeSelectionBox(
                        containertext: "Workouts",
                        containerroutename: "/WorkoutHome",
                        containerroutewidget: WorkoutHomeScreen(),
                        containerimageloc: "assets/workouts.png",
                        tintcolour: workoutsTintColour,
                      ),
                      HomeSelectionBox(
                        containertext: "Diet",
                        containerroutename: "/DietHome",
                        containerroutewidget: DietHomeScreen(),
                        containerimageloc: "assets/diet.png",
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

class CurvedClipper extends ContinuousRectangleBorder {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
