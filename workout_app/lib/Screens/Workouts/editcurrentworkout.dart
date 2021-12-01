import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Packages/horizontaltabs.dart';
import '../../constants.dart';

class EditCurrentWorkout extends StatefulWidget {
  EditCurrentWorkout({required this.workout, required this.set, required this.rep,
  required this.listID, required this.day, required this.index, required this.workouts,
  required this.workoutsSets, required this.workoutsReps});

  late String workout,
      set,
      rep,
      listID,
      day;
  late int index;
  late List workouts,
      workoutsSets,
      workoutsReps;
  final currentUser = supabase.auth.user();

  @override
  _EditCurrentWorkoutState createState() => _EditCurrentWorkoutState();
}

class _EditCurrentWorkoutState extends State<EditCurrentWorkout>
    with TickerProviderStateMixin {
  late final _workoutControllers = <TextEditingController>[];
  late final _setControllers = <TextEditingController>[];
  late final _repControllers = <TextEditingController>[];
  late final _workoutformkeys = <GlobalKey<FormState>>[];
  late final _setformkeys = <GlobalKey<FormState>>[];
  late final _repformkeys = <GlobalKey<FormState>>[];
  late TabController? tabControllerEdit;

  Future<void> _updateWorkouts() async {

    for (var i = 0; i < widget.workouts.length; i++) {
      widget.workouts[i] = _workoutControllers[i].text;
      widget.workoutsSets[i] = _setControllers[i].text;
      widget.workoutsReps[i] = _repControllers[i].text;
    }

    final _listID = widget.listID;
    final _user = widget.currentUser!.id;
    final _day = widget.day;
    final _workouts = widget.workouts;
    final _sets = widget.workoutsSets;
    final _reps = widget.workoutsReps;
    final updates = {
      "id": _listID,
      'userid': _user,
      'Day': _day,
      'Exercises': _workouts,
      "ExerciseSets": _sets,
      "ExerciseReps": _reps,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated Workout!')));
      Timer(Duration(milliseconds: 800), () {
        Navigator.pop(context);
      });
    }
  }

  void _onItemFocus(int index) {
    setState(() {
      tabControllerEdit!.index = index;
    });
  }

  void initState() {

    tabControllerEdit = TabController(
      length: widget.workouts.length,
      vsync: this,
    );

    tabControllerEdit!.index = widget.index;

    for (var i = 0; i < widget.workouts.length; i++) {
      _workoutControllers.add(TextEditingController(text: widget.workouts[i]));
      _setControllers.add(TextEditingController(text: widget.workoutsSets[i]));
      _repControllers.add(TextEditingController(text: widget.workoutsReps[i]));

      _workoutformkeys.add(GlobalKey<FormState>());
      _setformkeys.add(GlobalKey<FormState>());
      _repformkeys.add(GlobalKey<FormState>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
              appbaraccentcolour: WorkoutsAccentColour,
              appbarcolour: secondary,
              appbartitle: widget.day,
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
                          width:13*widget.workouts.length.toDouble(),
                          decoration: BoxDecoration(
                            color: tertiary,
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                          ),
                        ),
                      ),
                      Center(
                        child: TabPageSelectorHorizontal(
                          controller: tabControllerEdit,
                          color: tertiary,
                          selectedColor: WorkoutsAccentColour,
                          indicatorSize: 13,
/*                          direction: Direction.horizontal,
                          margin: 21,*/
                        ),
                      ),
                    ],
                  ),
                )),
          backgroundColor: primary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25, bottom: 25),
                  height: 500,
                  width: 300,
                  child: ScrollSnapList(
                    scrollDirection: Axis.horizontal,
                    onItemFocus: _onItemFocus,
                    itemSize: 300,
                    itemBuilder: _buildListItem,
                    itemCount: widget.workouts.length,
                    reverse: false,
                    initialIndex: widget.index.toDouble(),
                    scrollPhysics: BouncingScrollPhysics(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:30),
                  child: FloatingActionButton(
                    onPressed: () {
                      /*var _keycheck = 0;
                    for (var i = 0; i < widget.workouts.length; i++) {
                      if (
                      _workoutformkeys[i].currentState!.validate() &
                      _setformkeys[i].currentState!.validate() &
                      _repformkeys[i].currentState!.validate()) {
                        _keycheck++;
                      }
                    }
                    if (_keycheck == widget.workouts.length) {
                      _updateWorkouts();
                    }*/
                      _updateWorkouts();
                    },
                    elevation: 1,
                    hoverElevation: 1,
                    focusElevation: 0,
                    highlightElevation: 0,
                    backgroundColor: WorkoutsAccentColour,
                    child: Icon(
                      Icons.save,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          )
        ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
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
                    margin: EdgeInsets.only(top: 30, bottom: 20, right: 10, left: 10),
                    child: Form(
                      key: _workoutformkeys[index],
                      child: TextFormField(
                        controller: _workoutControllers[index],
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: tertiary,
                            fontSize: (30-(_workoutControllers[index].text.length.toDouble() / 3))
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter Workout',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            fontSize: 30,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Invalid Input';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30, right: 10, left: 10),
                    child: Form(
                      key: _setformkeys[index],
                      child: TextFormField(
                        controller: _setControllers[index],
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: tertiary,
                            fontSize: 30
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          suffixText: "Sets",
                          suffixStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 25,
                          ),
                          hintText: 'Enter Sets',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            fontSize: 30,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Invalid Input';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                    child: Form(
                      key: _repformkeys[index],
                      child: TextFormField(
                        controller: _repControllers[index],
                        cursorColor: Colors.white,
                        style: TextStyle(
                            color: tertiary,
                            fontSize: 30
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          suffixText: "Reps",
                          suffixStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 25,
                          ),
                          hintText: 'Enter Reps',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            fontSize: 30,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Invalid Input';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
