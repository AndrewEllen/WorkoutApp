import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Data/errorfeedback.dart';
import 'package:workout_app/Screens/Friends/pendingfriendslist.dart';
import "package:workout_app/constants.dart";
import 'package:flutter/material.dart';

import '../../router.dart';

class FriendsHomeScreen extends StatefulWidget {
  @override
  _FriendsHomeScreenState createState() => _FriendsHomeScreenState();
}

class _FriendsHomeScreenState extends State<FriendsHomeScreen> {
  final currentUser = supabase.auth.user();

  bool _loading = true;
  late var numoffriends;
  late String username;
  late List friendsList, pendingFriends;

  void initState() {
    friendsList = [];
    pendingFriends = [];
    _getProfile(currentUser!.id);
    _getFriends(currentUser!.id);
  }

  Future<void> _updateFriends(bool _createnew) async {
    final updates = {
      'id': currentUser!.id,
      'username': username,
      'friendslist': friendsList,
      'pendingfriends': pendingFriends,
    };
    final response = await supabase.from('friends').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
    if (_createnew == true) {
      final updates = {
        'id': currentUser!.id,
        "numoffriends": 0, //todo fix RLS
      };
      final response = await supabase.from('profiles').upsert(updates).execute();
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.error!.message),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _getProfile(String userId) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
      saveError(response.error!.message,"friendslist.dart");
    }
    if (response.data != null) {
      username = response.data!['username'];
      numoffriends = response.data!['numoffriends'];
    }
  }

  Future<void> _getFriends(String userId) async {
    final response = await supabase
        .from('friends')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
      saveError(response.error!.message,"friendslist.dart");
    }
    if (response.data != null) {
      username = response.data!['username'] as String;
      friendsList = response.data!['friendslist'] as List;
      pendingFriends = response.data!['pendingfriends'] as List;
    } else {
      if (numoffriends == null) {
        _updateFriends(true);
        numoffriends = 0;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ScreenData = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: primary,
            appBar: CustomAppBar(
              appbaraccentcolour: WorkoutsAccentColour,
              appbarcolour: secondary,
              appbartitle: "Friends",
            ),
            body: _loading ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ) : Container(
                margin: EdgeInsets.only(
                  left: ScreenData.width*0.01,
                  right: ScreenData.width*0.01,
                  top: ScreenData.height*0.03,
                  bottom: ScreenData.height*0.03,
                ),
                width: ScreenData.width,
                height: ScreenData.height,
                color: secondary,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: friendsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(left: 15),
                      height: 50,
                      color: primary,
                      margin: EdgeInsets.only(
                        top: 2,
                        bottom: 2,
                        left: 2,
                        right: 2,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          friendsList[index],
                          style: TextStyle(
                            color: tertiary,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Positioned(
            left: ScreenData.width*0.83,
            height: ScreenData.height*0.07,
            child: FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: () {
                Navigator.push(
                    context,
                    FadeRouter(
                      routeName: "friendslist",
                      screen: PendingFriendsHomeScreen(
                        username: username,
                        friendsList: friendsList,
                        pendingFriends: pendingFriends,
                        numoffriends: numoffriends,
                      ),
                    ));
              },
              elevation: 0,
              hoverElevation: 1,
              focusElevation: 0,
              highlightElevation: 0,
              backgroundColor: secondary,
              child: Icon(
                Icons.group_add,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

