import 'package:flutter/material.dart';
import '../../constants.dart';

class WorkoutsContainer extends StatefulWidget {
  WorkoutsContainer({required this.day});
  late String day;
  @override
  _WorkoutsContainerState createState() => _WorkoutsContainerState();
}

class _WorkoutsContainerState extends State<WorkoutsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 550,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppbarColour,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ListView(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  widget.day,
                  style: TextStyle(
                    color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
