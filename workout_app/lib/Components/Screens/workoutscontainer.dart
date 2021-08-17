import 'package:flutter/material.dart';
import 'package:workout_app/Components/Containers/workoutlistcontainer.dart';
import '../../constants.dart';

class WorkoutsContainer extends StatefulWidget {
  WorkoutsContainer({required this.day, required this.workouts, required this.currentUserID, required this.listID});
  late String day, currentUserID, listID;
  late List workouts;
  @override
  _WorkoutsContainerState createState() => _WorkoutsContainerState();
}

class _WorkoutsContainerState extends State<WorkoutsContainer> {

  Future<void> _updateWorkouts() async {
    final _listID = widget.listID;
    final _user = widget.currentUserID;
    final _day = widget.day;
    final _workouts = widget.workouts;
    final updates = {
      "id": _listID,
      'UserID': _user,
      'Day': _day,
      'Exercises': _workouts,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppbarColour,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: ListView.builder(
              itemCount: widget.workouts.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.workouts[index];
                return ClipRRect(
                  child: Dismissible(

                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        widget.workouts.removeAt(index);
                      });
                      _updateWorkouts();
                    ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
                    },
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Icon(Icons.delete)
                          )),
                    ),
                    child: Container(
                      child: WorkoutListContainer(
                        workout: widget.workouts[index],
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
