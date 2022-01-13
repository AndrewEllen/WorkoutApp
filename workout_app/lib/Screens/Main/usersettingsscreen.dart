import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:workout_app/Data/errorfeedback.dart';
import '../../constants.dart';
import '../../router.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String dropdownValueGoals = 'Maintain';
  String dropdownValueActivity = 'Sedentary';
  String dropdownValueGender = 'Male';
  late final _usernameController = TextEditingController();
  late final _avatarController = TextEditingController();
  late final _weightController = TextEditingController();
  late final _ageController = TextEditingController();
  late final _heightController = TextEditingController();
  final currentUser = supabase.auth.user();
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  final _formkey4 = GlobalKey<FormState>();
  final _formkey5 = GlobalKey<FormState>();
  final _formkey6 = GlobalKey<FormState>();
  var _loading = false;

  void initState() {
    _getProfile(currentUser!.id);
  }


  Future<String> daily_calories() async {
    var calories;
    var BMRmultActivity;
    var weight = double.parse(_weightController.text);
    var height = double.parse(_heightController.text);
    var age = double.parse(_ageController.text);

    if (dropdownValueActivity == "Sedentary") {
      BMRmultActivity = 1.2;
    }
    if (dropdownValueActivity == "Light") {
      BMRmultActivity = 1.375;
    }
    if (dropdownValueActivity == "Moderate") {
      BMRmultActivity = 1.55;
    }
    if (dropdownValueActivity == "Active") {
      BMRmultActivity = 1.725;
    }
    if (dropdownValueActivity == "Very Active") {
      BMRmultActivity = 1.9;
    }

    if (dropdownValueGender == "Male") {
      calories = ((66 + ((6.3 * (weight * 2.205)) + (12.9 * (height / 2.54)) - (6.8 * age)))*BMRmultActivity);
    }
    if (dropdownValueGender == "Female") {
      calories = ((655 + ((4.3 * (weight * 2.205)) + (4.7 * (height / 2.54)) - (4.7 * age)))*BMRmultActivity);
    }

    if (dropdownValueGoals == "Cut") {
      calories -= 400;
    }
    if (dropdownValueGoals == "Bulk") {
      calories += 400;
    }

    return calories.toString();
  }

  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
      saveError(response.error!.message,"usersettingsscreen.dart");
    }
    if (response.data != null) {
      _usernameController.text = response.data!['username'] as String;
      _avatarController.text = response.data!['avatar_url'] as String;
      _weightController.text = response.data!['weight'] as String;
      _ageController.text = response.data!['age'] as String;
      _heightController.text = response.data!['height'] as String;
      dropdownValueGoals = response.data!['goal'] as String;
      dropdownValueActivity = response.data!['activity'] as String;
      dropdownValueGender = response.data!['gender'] as String;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final user = supabase.auth.currentUser;
    final weight = _weightController.text;
    final age = _ageController.text;
    final height =_heightController.text;
    final goal = dropdownValueGoals;
    final activity = dropdownValueActivity;
    final gender = dropdownValueGender;
    final calories = await daily_calories();
    final updates = {
      'id': user!.id,
      'username': userName,
      'weight': weight,
      'age': age,
      'height': height,
      'goal': goal,
      'activity': activity,
      'gender': gender,
      'daily_calories': calories,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated profile!')));
      Timer(Duration(milliseconds: 800), () {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void onUnauthenticated() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        toolbarHeight: 260,
        title: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(left: 0, top: 0, bottom: 100),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(90),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(_loading ? _avatarController.text : 'https://i.imgur.com/yKV9vpH.png'),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(right: 0, top: 120),
                  child: Text(
                    'User: ${currentUser?.email}',
                    style: TextStyle(
                      fontSize: 13,
                      color: WorkoutsAccentColour,
                      shadows: [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.black,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 140),
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _formkey,
                  child: TextFormField(
                    controller: _usernameController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Username',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Invalid Username';
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey1,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  enableInteractiveSelection : false,
                  controller: _ageController,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: "Age",
                    hintText: 'Enter Age',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
        ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Invalid Age';
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  enableInteractiveSelection : false,
                  controller: _weightController,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: "Kg",
                    hintText: 'Enter Weight (Kg)',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Invalid Weight';
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey3,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  enableInteractiveSelection : false,
                  controller: _heightController,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: "CM",
                    hintText: 'Enter Height (CM)',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Invalid Height';
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey4,
                child: DropdownButton<String>(
                  dropdownColor: defaultLoginBackgroundColour,
                  value: dropdownValueGender,
                  elevation: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  underline: Container(
                    height: 2,
                    color: defaultLoginBackgroundColour,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueGender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey5,
                child: DropdownButton<String>(
                  dropdownColor: defaultLoginBackgroundColour,
                  value: dropdownValueGoals,
                  elevation: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  underline: Container(
                    height: 2,
                    color: defaultLoginBackgroundColour,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueGoals = newValue!;
                    });
                  },
                  items: <String>['Bulk', 'Maintain', 'Cut']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formkey6,
                child: DropdownButton<String>(
                  dropdownColor: defaultLoginBackgroundColour,
                  value: dropdownValueActivity,
                  elevation: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  underline: Container(
                    height: 2,
                    color: defaultLoginBackgroundColour,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueActivity = newValue!;
                    });
                  },
                  items: <String>['Sedentary','Light', 'Moderate', 'Active', 'Very Active']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate() &
                      _formkey1.currentState!.validate() &
                      _formkey2.currentState!.validate() &
                      _formkey3.currentState!.validate() &
                      _formkey4.currentState!.validate() &
                      _formkey5.currentState!.validate() &
                      _formkey6.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: WorkoutsAccentColour,
                ),
                child: Text(
                  _loading ? 'Saving...' : "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () {
              Navigator.push(
                  context,
                  FadeRouter(
                    routeName: "Settings",
                    screen: UserSettings2(),
                  ));
            },
            elevation: 1,
            hoverElevation: 1,
            focusElevation: 0,
            highlightElevation: 0,
            backgroundColor: WorkoutsAccentColour,
            child: Icon(
              Icons.group,
              size: 35,
            ),
          ),
        ],
      ),
    ));
  }
}











class UserSettings2 extends StatefulWidget {
  @override
  _UserSettings2State createState() => _UserSettings2State();
}

class _UserSettings2State extends State<UserSettings2> {
  late FixedExtentScrollController ageController;
  String dropdownValueGoals = 'Maintain';
  String dropdownValueActivity = 'Sedentary';
  String dropdownValueGender = 'Male';
  late final _usernameController = TextEditingController();
  late final _avatarController = TextEditingController();
  late final _weightController = TextEditingController();
  late final _ageController = TextEditingController();
  late final _heightController = TextEditingController();
  final currentUser = supabase.auth.user();
  final _formkey = GlobalKey<FormState>();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  final _formkey4 = GlobalKey<FormState>();
  final _formkey5 = GlobalKey<FormState>();
  final _formkey6 = GlobalKey<FormState>();
  var _loading = false;

  void initState() {
    ageController = FixedExtentScrollController();
    _getProfile(currentUser!.id);
  }

  Future<String> daily_calories() async {
    var calories;
    var BMRmultActivity;
    var weight = double.parse(_weightController.text);
    var height = double.parse(_heightController.text);
    var age = double.parse(_ageController.text);

    if (dropdownValueActivity == "Sedentary") {
      BMRmultActivity = 1.2;
    }
    if (dropdownValueActivity == "Light") {
      BMRmultActivity = 1.375;
    }
    if (dropdownValueActivity == "Moderate") {
      BMRmultActivity = 1.55;
    }
    if (dropdownValueActivity == "Active") {
      BMRmultActivity = 1.725;
    }
    if (dropdownValueActivity == "Very Active") {
      BMRmultActivity = 1.9;
    }

    if (dropdownValueGender == "Male") {
      calories = ((66 + ((6.3 * (weight * 2.205)) + (12.9 * (height / 2.54)) - (6.8 * age)))*BMRmultActivity);
    }
    if (dropdownValueGender == "Female") {
      calories = ((655 + ((4.3 * (weight * 2.205)) + (4.7 * (height / 2.54)) - (4.7 * age)))*BMRmultActivity);
    }

    if (dropdownValueGoals == "Cut") {
      calories -= 400;
    }
    if (dropdownValueGoals == "Bulk") {
      calories += 400;
    }

    return calories.toString();
  }

  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
      saveError(response.error!.message,"usersettingsscreen.dart");
    }
    if (response.data != null) {
      _usernameController.text = response.data!['username'] as String;
      _avatarController.text = response.data!['avatar_url'] as String;
      _weightController.text = response.data!['weight'] as String;
      _ageController.text = response.data!['age'] as String;
      _heightController.text = response.data!['height'] as String;
      dropdownValueGoals = response.data!['goal'] as String;
      dropdownValueActivity = response.data!['activity'] as String;
      dropdownValueGender = response.data!['gender'] as String;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final user = supabase.auth.currentUser;
    final weight = _weightController.text;
    final age = _ageController.text;
    final height =_heightController.text;
    final goal = dropdownValueGoals;
    final activity = dropdownValueActivity;
    final gender = dropdownValueGender;
    final calories = await daily_calories();
    final updates = {
      'id': user!.id,
      'username': userName,
      'weight': weight,
      'age': age,
      'height': height,
      'goal': goal,
      'activity': activity,
      'gender': gender,
      'daily_calories': calories,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated profile!')));
      Timer(Duration(milliseconds: 800), () {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void onUnauthenticated() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ScreenData = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: primary,
          appBar: AppBar(
            backgroundColor: secondary,
            toolbarHeight: ScreenData.height / 3.6,
            title: Center(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: ScreenData.height / 9,
                      height: ScreenData.height / 9,
                      margin: EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(45),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(_loading ? _avatarController.text : 'https://i.imgur.com/yKV9vpH.png'),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(right: 0, top: ScreenData.height / 6.85),
                      child: Text(
                        'User: ${currentUser?.email}',
                        style: TextStyle(
                          fontSize: 16,
                          color: WorkoutsAccentColour,
                          shadows: [
                            Shadow(
                              blurRadius: 1,
                              color: Colors.black,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenData.height / 5.8),
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Form(
                        key: _formkey,
                        child: TextFormField(
                          controller: _usernameController,
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter Username',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Invalid Username';
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            shadowColor: secondary,
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            children: [
              Positioned(
                top: ScreenData.height / 50,
                left: ScreenData.width / 80,
                  child: Container(
                    height: 200,
                    width: 400,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 50,
                      physics: FixedExtentScrollPhysics(),
                      perspective: 0.01,
                      diameterRatio: 1.8,
                      squeeze: 1.2,
                      onSelectedItemChanged: (index) => print(index),
                      controller: ageController,

                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 68,
                          builder: (BuildContext context, int index) {
                            return Card(
                              child: Container(
                                width: 40,
                                  child: Center(
                                    child: Text(
                                      "${index+18}",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                              ),
                            );
                          }),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}