import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/Screens/homeworkoutscontainer.dart';
import 'package:workout_app/Components/SideBar/sidebar.dart';
import 'package:workout_app/Data/Screens/feedback.dart';
import 'package:workout_app/data/Screens/workouthome.dart';
import '../../constants.dart';

class WorkoutHomeScreen extends StatefulWidget {
  @override
  _WorkoutHomeScreenState createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  List sidebardata = [], feedbackdata = [];
  final currentUser = supabase.auth.user();
  String dropdownValueDay = "Monday";
  final _Dayformkey = GlobalKey<FormState>();
  late String day, listID;
  late List workouts,completedlist,_completedlist;
  bool _loading = true;
  late bool _completed;

  Future<void> _updateWorkouts() async {
    final _listID = listID;
    final _user = currentUser!.id;
    final _day = day;
    final _completed = completedlist;
    final updates = {
      "id": _listID,
      'UserID': _user,
      'Day': _day,
      'Exercises': _completed,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
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
      completedlist = response.data!['Completed'] as List;
      _completedlist = completedlist;
    }
    var i;
    for (i=0; i < completedlist.length; i++) {
      if (completedlist[i] == "true"){
        _completed = true;
        completedlist[i] = _completed;

      } else {
        _completed = false;
        completedlist[i] = _completed;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  void initState() {
    sidebardata = SideBarWorkout.getContents();
    feedbackdata = SideBarFeedback.getContents();
    _getWorkouts(currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: WorkoutsAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: "Workouts",
        ),
        drawer: CustomSideBar(
          sidebaraccentcolour: WorkoutsAccentColour,
          sidebarcolour: SideBarColour,
          sidebartitle: "Meals",
          feedbacktitle: "Feedback",
          sidebardata: sidebardata,
          feedbackdata: feedbackdata,
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
                child: Container(
                  child: HomeWorkoutsContainer(
                    widthvalue: 580,
                    day: _loading ? "loading..." : day,
                    workouts: _loading? ["loading..."] : workouts,
                    completedlist: _loading? [false] : completedlist,
                    currentUserID: _loading? "loading..." : currentUser!.id,
                    listID: _loading? "loading..." :  listID,
                    completedliststring: _loading? ["loading..."] : _completedlist,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
