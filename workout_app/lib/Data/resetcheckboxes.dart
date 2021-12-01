import 'package:flutter/cupertino.dart';

import '../constants.dart';

Future<void> resettickboxes(day, daytosave, userId) async {
  late String listID = "null";
  late List completedlist = [];
  late var lastsaveday = daytosave;

  Future<void> _getWorkouts(String userId, String day) async {
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('userid', userId)
        .eq('Day', day)
        .single()
        .execute();
    if (response.data != null) {
      listID = response.data!["id"] as String;
      completedlist = response.data!['Completed'] as List;
      lastsaveday = response.data!['lastdate'];
    }
  }

  Future<void> _updateWorkouts(day, daytosave) async {
    final _listID = listID;
    final _user = userId;
    final _day = day;
    final _daytosave = daytosave;
    final _completedlist = completedlist;
    final updates = {
      "id": _listID,
      'userid': _user,
      'Day': _day,
      'Completed': _completedlist,
      "lastdate": _daytosave,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      print("Error");
    }
  }

  await _getWorkouts(userId, day);

  if (lastsaveday == null) {
    print("Created");
    _updateWorkouts(day, daytosave);
  }
  if (lastsaveday != daytosave) {
    print("Saved");
    for (var i = 0; i < completedlist.length; i++) {
      completedlist[i] = "false";
    }
    _updateWorkouts(day, daytosave);
  }

}