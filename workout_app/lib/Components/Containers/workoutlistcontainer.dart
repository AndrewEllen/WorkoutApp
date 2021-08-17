import 'package:flutter/material.dart';

class WorkoutListContainer extends StatelessWidget {
  WorkoutListContainer ({required this.workout});
  late String workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, bottom: 10,right:10),
        child: Text(
          workout,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
