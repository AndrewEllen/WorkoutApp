import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar.dart';
import 'package:workout_app/Components/sidebar.dart';
import '../constants.dart';

class DietHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: DietAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: "Diet",
        ),
        drawer: CustomSideBar(
          sidebaraccentcolour: DietAccentColour,
          sidebarcolour: SideBarColour,
        ),
      ),
    );
  }
}
