import 'package:flutter/material.dart';
import 'package:workout_app/Components/homeselectionboxes.dart';
import 'package:workout_app/screens/index.dart';
import '../constants.dart';

class HomeScreen2 extends StatelessWidget {
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
                              offset: Offset(1,2),
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
                ],
              ),
            )));
  }
}
