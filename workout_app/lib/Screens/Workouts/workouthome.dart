import 'package:flutter/material.dart';
import 'package:scroll_indicator/scroll_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:workout_app/Components/Containers/workoutbox.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/SideBar/sidebar.dart';
import 'package:workout_app/Data/Screens/feedback.dart';
import 'package:workout_app/Data/Screens/settings.dart';
import 'package:workout_app/Data/resetcheckboxes.dart';
import 'package:workout_app/data/Screens/workouthome.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

// https://dartpad.dev/?null_safety=true&id=afc693da482659e918d46a21c5e80ae4

class WorkoutHomeScreen extends StatefulWidget {
  @override
  _WorkoutHomeScreenState createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen>
    with SingleTickerProviderStateMixin {
  List sidebardata = [], feedbackdata = [];
  final currentUser = supabase.auth.user();
  var yesterday = DateTime.now().subtract(Duration(days: 1));
  var today = DateTime.now();
  final dropdownlist = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String dropdownValueDay = "Monday";
  late String day, listID;
  late List workouts = [],
      workoutsSets = [],
      workoutsReps = [],
      completedlist = [],
      _completedlist = [],
      settingsdata = [];
  bool _loading = true;
  late bool _completed;
  late TabController? tabController;
  late ScrollController scrollBarController = ScrollController();

  Future<void> _getWorkouts(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('userid', userId)
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
      workoutsSets = response.data!['ExerciseSets'] as List;
      workoutsReps = response.data!['ExerciseReps'] as List;
      completedlist = response.data!['Completed'] as List;
      _completedlist = completedlist;
    }
    var i;
    for (i = 0; i < completedlist.length; i++) {
      if (completedlist[i] == "true") {
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

  Future<Null> _refresh() {
    return _getWorkouts(currentUser!.id).then((_workouts) {
      setState(() => workouts);
    });
  }

  void _setTabIndex() {
    tabController!.index = dropdownlist.indexWhere(
        (dropdownlist) => dropdownlist.startsWith(dropdownValueDay));
  }

  void _onItemFocus(int index) {
    setState(() {
      tabController!.index = index;
      dropdownValueDay = dropdownlist[index];
      _getWorkouts(currentUser!.id);
    });
  }

  void initState() {
    tabController = TabController(
      length: dropdownlist.length,
      vsync: this,
    );

    if (int.parse(DateFormat('HH').format(today)) < 4) {
      dropdownValueDay = DateFormat('EEEE').format(yesterday);
    } else {
      dropdownValueDay = DateFormat('EEEE').format(today);
      resettickboxes(DateFormat('EEEE').format(yesterday), currentUser!.id);
    }
    _setTabIndex();
    sidebardata = SideBarWorkout.getContents();
    feedbackdata = SideBarFeedback.getContents();
    settingsdata = SideBarSettings.getContents();
    _getWorkouts(currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: primary,
            appBar: CustomAppBar(
              appbaraccentcolour: WorkoutsAccentColour,
              appbarcolour: secondary,
              appbartitle: "$dropdownValueDay",
            ),
            drawer: CustomSideBar(
              sidebaraccentcolour: WorkoutsAccentColour,
              sidebarcolour: SideBarColour,
              sidebartitle: "Meals",
              feedbacktitle: "Feedback",
              settingstitle: "Settings",
              sidebardata: sidebardata,
              feedbackdata: feedbackdata,
              settingsdata: settingsdata,
            ),
            body: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 30),
                    width: 300,
                    height: 550,
                    child: Expanded(
                      child: ScrollSnapList(
                        scrollDirection: Axis.vertical,
                        onItemFocus: _onItemFocus,
                        itemSize: 550,
                        itemBuilder: _buildListItem,
                        itemCount: dropdownlist.length,
                        reverse: false,
                        initialIndex: tabController!.index.toDouble(),
                        updateOnScroll: true,
                        scrollPhysics: BouncingScrollPhysics(),
                      ),
                    ),
                  ),
                  TabPageSelector(
                    controller: tabController,
                    color: Colors.white,
                    selectedColor: WorkoutsAccentColour,
                    indicatorSize: 13,
                    direction: Direction.vertical,
                    margin: 21,
                  ),
                ]),
              ],
            )));
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 25, bottom: 25),
            height: 500,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WorkoutBox(
                  workouts: _loading ? ["loading..."] : workouts,
                  sets: _loading ? ["loading..."] : workoutsSets,
                  reps: _loading ? ["loading..."] : workoutsReps,
                ),
              ],
            ))
      ],
    ));
  }
}
