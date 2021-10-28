import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import '../../constants.dart';

class WorkoutBox extends StatefulWidget {
  WorkoutBox({required this.workouts, required this.sets, required this.reps});
  late List workouts;
  late List sets;
  late List reps;

  @override
  _WorkoutBoxState createState() => _WorkoutBoxState();
}

class _WorkoutBoxState extends State<WorkoutBox> {
  late int workoutIndex;

  void _onItemFocus(int index) {
    setState(() {
      workoutIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 500,
      child: Expanded(
        child: ScrollSnapList(
          scrollDirection: Axis.horizontal,
          onItemFocus: _onItemFocus,
          itemSize: 300,
          itemBuilder: _buildListItem,
          itemCount: widget.workouts.length,
          reverse: false,
          initialIndex: 0,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 25, right: 25,),
              height: 300,
              width: 250,
              color: secondary,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40, bottom: 40),
                    child: Text(
                      "${widget.workouts[index]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 40),
                    child: Text(
                        "${widget.sets[index]} Sets",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                        "${widget.reps[index]} Reps",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ),
                ],
              ),
            )
          ],
        )
    );
  }
}
