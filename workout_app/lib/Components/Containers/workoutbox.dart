import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class WorkoutBox extends StatefulWidget {
  WorkoutBox({required this.workouts});
  late List workouts;

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
      color: Colors.green,
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
              height: 500,
              width: 300,
              color: Colors.grey,
              child: Text(
                "${widget.workouts[index]}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
    );
  }
}
