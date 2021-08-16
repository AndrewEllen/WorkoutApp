import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
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

  void initState() {
    sidebardata = SideBarWorkout.getContents();
    feedbackdata = SideBarFeedback.getContents();
    //_getProfile(currentUser!.id);
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
          sidebaraccentcolour: DietAccentColour,
          sidebarcolour: SideBarColour,
          sidebartitle: "Meals",
          feedbacktitle: "Feedback",
          sidebardata: sidebardata,
          feedbackdata: feedbackdata,
        ),
      ),
    );
  }
}
