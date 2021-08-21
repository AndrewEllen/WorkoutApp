
class WorkoutsObj {
  final currentUser;
  final day;
  final listID;
  final List workouts, completedlist, completedlistbool;
  final String dropdownValueDay;
  final bool completed;

  WorkoutsObj({
    required this.currentUser,
    required this.day,
    required this.listID,
    required this.workouts,
    required this.completedlist,
    required this.completedlistbool,
    required this.dropdownValueDay,
    required this.completed,
  });
}