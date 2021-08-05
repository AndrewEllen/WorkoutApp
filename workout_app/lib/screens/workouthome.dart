import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar.dart';
import 'package:workout_app/Components/sidebar.dart';
import '../constants.dart';

class WorkoutHomeScreen extends StatelessWidget {
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
        ),
      ),
    );
  }
}
