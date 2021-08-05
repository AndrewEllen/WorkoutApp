import 'package:flutter/material.dart';
import 'package:workout_app/Components/homeselectionboxes.dart';

import '../constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeSelectionBox(
                containertext: "Workouts",
                containerroute: "/WorkoutHome",
                containerimageloc: "assets/workouts.jpg",
                tintcolour: workoutsTintColour,
              ),
              HomeSelectionBox(
                containertext: "Diet",
                containerroute: "/DietHome",
                containerimageloc: "assets/diet.jpg",
                tintcolour: dietTintColour,
              ),
          ],
          ),
        )
      )
    );
  }
}
