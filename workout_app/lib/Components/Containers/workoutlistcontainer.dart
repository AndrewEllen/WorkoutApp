import 'package:flutter/material.dart';
import '../../constants.dart';

class WorkoutListContainer extends StatelessWidget {
  WorkoutListContainer ({required this.workout});
  late String workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(1, 1, 1, 0.75),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 50),
          )
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 10, bottom: 10,right:10),
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
