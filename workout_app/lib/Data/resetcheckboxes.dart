import '../constants.dart';

Future<void> resettickboxes(day, daylist, userId) async {
  late String listID = "null";
  late List completedlist = [];
  int daytoskip = daylist.indexOf('$day');

  Future<void> _getWorkouts(String userId, String currentDay) async {
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('userid', userId)
        .eq('Day', currentDay)
        .single()
        .execute();
    if (response.data != null) {
      listID = response.data!["id"] as String;
      completedlist = response.data!['Completed'] as List;
      print(completedlist);
    }
  }

  Future<void> _updateWorkouts(currentDay) async {
    final _listID = listID;
    final _user = userId;
    final _day = currentDay;
    final _completedlist = completedlist;
    final updates = {
      "id": _listID,
      'userid': _user,
      'Day': _day,
      'Completed': _completedlist,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
    }
  }

  for (var i = 0; i < daylist.length; i++) {
    if (i != daytoskip) {
      await _getWorkouts(userId, daylist[i]);

      for (var x = 0; x < completedlist.length; x++) {
        completedlist[x] = "false";
      }
      await _updateWorkouts(daylist[i]);
      print(i);
      print(completedlist);
    }
  }

}