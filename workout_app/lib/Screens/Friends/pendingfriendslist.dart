import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Data/errorfeedback.dart';
import "package:workout_app/constants.dart";
import 'package:flutter/material.dart';

class PendingFriendsHomeScreen extends StatefulWidget {
  PendingFriendsHomeScreen({required this.username, required this.friendsList, required this.pendingFriends, required this.numoffriends});
  String username;
  int numoffriends;
  List friendsList, pendingFriends;

  @override
  _PendingFriendsHomeScreenState createState() => _PendingFriendsHomeScreenState();
}

class _PendingFriendsHomeScreenState extends State<PendingFriendsHomeScreen> {
  final currentUser = supabase.auth.user();

  Future<void> _updateFriends() async {
    final updates1 = {
      'id': currentUser!.id,
      'username': widget.username,
      'friendslist': widget.friendsList,
      'pendingfriends': widget.pendingFriends,
    };
    final response1 = await supabase.from('friends').upsert(updates1).execute();
    if (response1.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response1.error!.message),
        backgroundColor: Colors.red,
      ));
    }

    final updates2 = {
      'id': currentUser!.id,
      "numoffriends": widget.numoffriends,
    };
    final response2 = await supabase.from('profiles').upsert(updates2).execute();
    if (response2.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response2.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var ScreenData = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
        appBar: CustomAppBar(
          appbaraccentcolour: WorkoutsAccentColour,
          appbarcolour: secondary,
          appbartitle: "Friend Requests",
        ),
        body: Container(
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
            itemCount: widget.pendingFriends.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(left: 15, right:15),
                height: 60,
                color: primary,
                margin: EdgeInsets.only(
                  top: 2,
                  bottom: 2,
                  left: 2,
                  right: 2,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.pendingFriends[index],
                        style: TextStyle(
                          color: tertiary,
                          fontSize: (30 - (widget.pendingFriends[index].length/2)).toDouble(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 0,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(45))
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.pendingFriends.removeAt(index);
                                  _updateFriends();
                                });
                              },

                              icon: Icon(
                                Icons.thumb_down,
                                size: 30,
                                color: tertiary,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(45))
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.friendsList.add(widget.pendingFriends[index]);
                                  widget.pendingFriends.removeAt(index);
                                  widget.numoffriends += 1;
                                  _updateFriends();
                                });
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                size: 30,
                                color: tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

