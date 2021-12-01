import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:workout_app/Components/Containers/workoutlistcheckbox.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/SideBar/sidebar.dart';
import 'package:workout_app/Data/Screens/feedback.dart';
import 'package:workout_app/Data/Screens/settings.dart';
import 'package:workout_app/Data/resetcheckboxes.dart';
import 'package:workout_app/Packages/verticaltabs.dart';
import 'package:workout_app/Packages/horizontaltabs.dart';
import 'package:workout_app/Screens/Workouts/editcurrentworkout.dart';
import 'package:workout_app/Screens/Workouts/workoutsscreen.dart';
import 'package:workout_app/data/Screens/workouthome.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

import '../../router.dart';

// https://dartpad.dev/?null_safety=true&id=afc693da482659e918d46a21c5e80ae4

class WorkoutHomeScreen extends StatefulWidget {
  @override
  _WorkoutHomeScreenState createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen>
    with TickerProviderStateMixin {
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
  late TabController? tabControllerWorkouts;

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
      workouts = response.data!['Exercises'];
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
    tabControllerWorkouts = TabController(
      length: workouts.length,
      vsync: this,
    );
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

  void _onItemFocusWorkouts(int index) {
    setState(() {
      tabControllerWorkouts!.index = index;
    });
  }

  void initState() {
    if (int.parse(DateFormat('HH').format(today)) < 4) {
      dropdownValueDay = DateFormat('EEEE').format(yesterday);
    } else {
      dropdownValueDay = DateFormat('EEEE').format(today);
      resettickboxes(dropdownValueDay, dropdownlist, currentUser!.id);
    }

    tabControllerWorkouts = TabController(
      length: 0,
      vsync: this,
    );
    tabController = TabController(
      length: dropdownlist.length,
      vsync: this,
    );
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
            bottomNavigationBar: BottomAppBar(
                color: secondary,
                child: Container(
                  height: 60,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height:13.5,
                          width:13*workouts.length.toDouble(),
                          decoration: BoxDecoration(
                            color: tertiary,
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                          ),
                        ),
                      ),
                      Center(
                          child: TabPageSelectorHorizontal(
                            controller: tabControllerWorkouts,
                            color: tertiary,
                            selectedColor: WorkoutsAccentColour,
                            indicatorSize: 13,
/*                            direction: Direction.horizontal,
                            margin: 21,*/
                          ),
                      ),
                    ],
                  ),
                )),
            drawer: CustomSideBar(
              sidebaraccentcolour: WorkoutsAccentColour,
              sidebarcolour: SideBarColour,
              sidebartitle: "Workouts",
              feedbacktitle: "Feedback",
              settingstitle: "Settings",
              sidebardata: sidebardata,
              feedbackdata: feedbackdata,
              settingsdata: settingsdata,
            ),
            body: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 15),
                    width: 300,
                    height: 550,
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
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: TabPageSelectorVertical(
                      controller: tabController,
                      color: Colors.white,
                      selectedColor: WorkoutsAccentColour,
                      indicatorSize: 13,
/*                      direction: Direction.vertical,
                      margin: 21,*/
                    ),
                  ),
                ]),
                Container(
                  margin: EdgeInsets.only(top:30),
                  child: FloatingActionButton(onPressed: (){
                    Navigator.push(
                        context,
                        FadeRouter(
                          routeName: "editworkout",
                          screen: EditCurrentWorkout(
                            workout: workouts[tabControllerWorkouts!.index],
                            set: workoutsSets[tabControllerWorkouts!.index],
                            rep: workoutsReps[tabControllerWorkouts!.index],
                            workouts: workouts,
                            workoutsSets: workoutsSets,
                            workoutsReps: workoutsReps,
                            day: day,
                            listID: listID,
                            index: tabControllerWorkouts!.index,
                          ),
                        ));
                  },
                    elevation: 1,
                    hoverElevation: 1,
                    focusElevation: 0,
                    highlightElevation: 0,
                    backgroundColor: WorkoutsAccentColour,
                    child: Icon(
                      Icons.edit,
                      size: 35,
                    ),
                  ),
                )
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
          child: ScrollSnapList(
            scrollDirection: Axis.horizontal,
            onItemFocus: _onItemFocusWorkouts,
            itemSize: 300,
            itemBuilder: _buildListItemWorkouts,
            itemCount: workouts.length,
            reverse: false,
            initialIndex: 0,
            scrollPhysics: BouncingScrollPhysics(),
          ),
        ),
      ],
    ));
  }

  Widget _buildListItemWorkouts(BuildContext context, int index) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              height: 350,
              width: 250,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40, bottom: 20),
                    child: workouts[index].length != 0 ?
                    Text(
                      "${workouts[index]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ) :
                    Text(
                      "No Workout",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    child: workoutsSets[index].length != 0 ?
                    Text(
                      "${workoutsSets[index]} Sets",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ) :
                    Text(
                      "0 Sets",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: workoutsReps[index].length != 0 ?
                    Text(
                      "${workoutsReps[index]} Reps",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ) :
                    Text(
                      "0 Reps",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  WorkoutListCheckbox(
                    day: dropdownValueDay,
                    completed: completedlist[index],
                    currentUserID: currentUser!.id,
                    index: index,
                    listID: listID,
                    completedlist: completedlist,
                    completedliststring: _completedlist,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
