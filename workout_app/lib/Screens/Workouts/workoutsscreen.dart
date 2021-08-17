import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/Screens/workoutscontainer.dart';
import '../../constants.dart';

class WorkoutListScreen extends StatefulWidget {
  WorkoutListScreen(
      {required this.appbartitle});
  final String appbartitle;

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final currentUser = supabase.auth.user();
  String dropdownValueDay = "Monday";
  final _Dayformkey = GlobalKey<FormState>();
  late String day, listID;
  late List workouts;
  bool _loading = true;

  void initState() {
    _getWorkouts(currentUser!.id);
  }

  Future<void> _getWorkouts(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('UserID', userId)
        .eq('Day', dropdownValueDay)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      listID = response.data!["id"] as String;
      day = response.data!['Day'] as String;
      workouts = response.data!['Exercises'] as List;
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
          appbaraccentcolour: WorkoutsAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: widget.appbartitle,
        ),
        body: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _Dayformkey,
                  child: DropdownButton<String>(
                    dropdownColor: defaultLoginBackgroundColour,
                    value: dropdownValueDay,
                    elevation: 1,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    underline: Container(
                      height: 2,
                      color: defaultLoginBackgroundColour,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValueDay = newValue!;
                      });
                      _getWorkouts(currentUser!.id);
                    },
                    items: <String>['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: WorkoutsContainer(
                day: _loading ? "loading..." : day,
                workouts: _loading? ["loading..."] : workouts,
                currentUserID: currentUser!.id,
                listID: listID,
              )
            ),
          ],
        ),
      ),
    );
  }
}
