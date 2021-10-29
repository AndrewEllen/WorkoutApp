import 'dart:async';

import 'package:flutter/material.dart';
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

class _EditCurrentWorkoutState extends State<EditCurrentWorkout> {
  late final _workoutController = TextEditingController();
  late final _setsController = TextEditingController();
  late final _repsController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();

  Future<void> _updateWorkouts() async {

    widget.workouts[widget.index] = _workoutController.text;
    widget.workoutsSets[widget.index] = _setsController.text;
    widget.workoutsReps[widget.index] = _repsController.text;

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

  void initState() {
    _workoutController.text = widget.workout;
    _setsController.text = widget.set;
    _repsController.text = widget.rep;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: primary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                                child: Form(
                                  key: _formkey,
                                  child: TextFormField(
                                    controller: _workoutController,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Username',
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: new BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid Input';
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30, bottom: 30),
                                child: Form(
                                  key: _formkey1,
                                  child: TextFormField(
                                    controller: _setsController,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      suffixText: "Sets",
                                      suffixStyle: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      hintText: 'Enter Sets',
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: new BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid Input';
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Form(
                                  key: _formkey2,
                                  child: TextFormField(
                                    controller: _repsController,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      suffixText: "Reps",
                                      suffixStyle: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      hintText: 'Enter Reps',
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 0.4),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: new BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid Input';
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top:30),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate() &
                      _formkey1.currentState!.validate() &
                      _formkey2.currentState!.validate()) {
                        _updateWorkouts();
                      }
                    },
                        elevation: 1,
                        hoverElevation: 1,
                        focusElevation: 0,
                        highlightElevation: 0,
                        backgroundColor: WorkoutsAccentColour,
                  ),
                )
              ],
            ),
          )
        ),
    );
  }
}
