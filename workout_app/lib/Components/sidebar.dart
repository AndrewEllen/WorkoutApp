import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class CustomSideBar extends StatelessWidget {
  CustomSideBar({required this.sidebaraccentcolour, required this.sidebarcolour});
  final Color sidebaraccentcolour, sidebarcolour;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: sidebarcolour,
      ),
    );
  }
}

