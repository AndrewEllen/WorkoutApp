import 'package:flutter/material.dart';

//Screens
const Color defaultBackgroundColour = Color.fromRGBO(38, 38, 38, 1.0);

//HomeScreen

const double boxSelectionHeight = 175;
const double boxSelectionWidth = 500;

const Color workoutsTintColour = Color.fromRGBO(2, 52, 182, 0.4);
const Color dietTintColour = Color.fromRGBO(32, 142, 26, 0.4);

const boxSelectionDecoration = BoxDecoration(
  color: Colors.white70,
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
  boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(1, 1, 1, 0.75),
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 8),
    )
  ],
);