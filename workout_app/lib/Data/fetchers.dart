import '../constants.dart';
import 'models/userworkouts.dart';

class getWorkouts {
  late final userworkoutsdata;
  final currentUser = supabase.auth.user();
  late String day, listID;
  late List workouts, completedlist, _completedlist;
  String dropdownValueDay = "Monday";
  late bool _completed;

  Future<List<WorkoutsObj>> _getWorkouts(String userId) async {
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('UserID', userId)
        .eq('Day', dropdownValueDay)
        .single()
        .execute();

    if (response.data != null) {
      listID = response.data!["id"] as String;
      day = response.data!['Day'] as String;
      workouts = response.data!['Exercises'] as List;
      completedlist = response.data!['Completed'] as List;
      _completedlist = completedlist;
    }
    var i;
    for (i = 0; i < completedlist.length; i++) {
      if (completedlist[i] == "true") {
        _completed = true;
        completedlist[i] = _completed;
      } else {
        _completed = false;
        completedlist[i] = _completed;
      }
    }
    return [
      WorkoutsObj(
          completedlist: completedlist,
          workouts: workouts,
          completedlistbool: _completedlist,
          completed: _completed,
          currentUser: currentUser,
          listID: listID,
          dropdownValueDay: dropdownValueDay,
          day: day
      ),
    ];
  }
}