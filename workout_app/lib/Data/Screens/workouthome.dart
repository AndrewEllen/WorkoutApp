import 'package:workout_app/Screens/Main/homescreen.dart';
import '../models/sidebartextmodel.dart';

class SideBarWorkout {
  static List<SideBarText> getContents() {
    return [
      SideBarText(
        settingsText: "Workouts",
        textLink: "/workouts",
        routerWidget: HomeScreen(),
        //routerWidget: WorkoutsListScreen(),
      ),
    ];
  }
}
