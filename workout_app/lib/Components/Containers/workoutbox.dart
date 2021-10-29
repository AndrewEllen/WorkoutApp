import 'package:flutter/material.dart';
import 'package:scroll_indicator/scroll_indicator.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import '../../constants.dart';

//https://www.digitalocean.com/community/tutorials/flutter-widget-communication

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
  final ScrollController scrollBarController = ScrollController();

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
        child: ScrollSnapList(
          listController: scrollBarController,
          scrollDirection: Axis.horizontal,
          onItemFocus: _onItemFocus,
          itemSize: 300,
          itemBuilder: _buildListItem,
          itemCount: widget.workouts.length,
          reverse: false,
          initialIndex: 0,
          scrollPhysics: BouncingScrollPhysics(),
          ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(left: 25, right: 25,),
              height: 350,
              width: 250,
              child: Column(
                children: [
                    Container(
                    margin: EdgeInsets.only(top: 40, bottom: 20),
                    child: Text(
                      "${widget.workouts[index]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    child: Text(
                        "${widget.sets[index]} Sets",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                        "${widget.reps[index]} Reps",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ),
                ],
              ),
            ),
            BottomAppBar(
                color: Colors.white,
                child: ScrollIndicator(
                  scrollController: scrollBarController,

                )
            ),
          ],
        )
    );
  }
}
