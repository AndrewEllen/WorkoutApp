import 'package:flutter/material.dart';
import 'package:workout_app/Components/Containers/workoutlistcontainer.dart';
import '../../constants.dart';

class WorkoutsContainer extends StatefulWidget {
  WorkoutsContainer({required this.day, required this.workouts});
  late String day;
  late List workouts;
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
      child: ListView.builder(
            itemCount: widget.workouts.length,
            itemBuilder: (BuildContext context, int index) {
              final item = widget.workouts[index];
              return Dismissible(

                key: Key(item),

                onDismissed: (direction) {
                  setState(() {
                    widget.workouts.removeAt(index);
                  });
                ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$item dismissed')));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: WorkoutListContainer(
                    workout: widget.workouts[index],
                  ),
                ),
              );
            },
          ),
    );
  }
}
