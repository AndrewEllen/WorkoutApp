import 'package:workout_app/Components/Navbar/Navbar.dart';
import "package:workout_app/constants.dart";
import 'package:flutter/material.dart';

class FriendsHomeScreen extends StatefulWidget {
  @override
  _FriendsHomeScreenState createState() => _FriendsHomeScreenState();
}

class _FriendsHomeScreenState extends State<FriendsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var ScreenData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        appBar: CustomAppBar(
          appbaraccentcolour: WorkoutsAccentColour,
          appbarcolour: secondary,
          appbartitle: "Friends",
        ),
        body: Container(
          padding,
          width: ScreenData.size.width,
          height: ScreenData.size.width,
          color: secondary,
        ),
      ),
    );
  }
}

