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
  late var friendID;
  late List friendPendingFriends;

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

  Future<void> _sendFriendRequest(String friendusername) async {
    final response = await supabase
        .from('friends')
        .select()
        .eq('username', friendusername)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
      saveError(response.error!.message, "pendingfriendslist.dart");
    }
    if (response.data != null) {
      friendID = response.data!['id'];
      friendPendingFriends = response.data['pendingfriends'] as List;
    }

    print(friendID);
    print(currentUser!.id);

    friendPendingFriends.add(widget.username);
    final updates = {
      'id': friendID,
      'pendingfriends': friendPendingFriends,
    };
    final response1 = await supabase.from('friends').upsert(updates).execute();
    if (response1.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response1.error!.message),
        backgroundColor: Colors.red,
      ));
    }
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
              appbartitle: "Requests",
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
          Positioned(
            left: ScreenData.width*0.83,
            height: ScreenData.height*0.07,
            child: FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: () {
                showConfirmationBox(context);
              },
              elevation: 0,
              hoverElevation: 1,
              focusElevation: 0,
              highlightElevation: 0,
              backgroundColor: secondary,
              child: Icon(
                Icons.add_circle,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final _addfriendformkey = GlobalKey<FormState>();
  late final _friendsusername = TextEditingController();

  showConfirmationBox(BuildContext context) {
    return showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            title: Form(
              key: _addfriendformkey,
              child: TextFormField(
                controller: _friendsusername,
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
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_addfriendformkey.currentState!.validate()) {
                    _sendFriendRequest(_friendsusername.text);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: WorkoutsAccentColour,
                  minimumSize: Size(130, 38),
                ),
                child: Text(
                  "Send",
                  style: TextStyle(
                    color: tertiary,
                    fontSize: 22,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: WorkoutsAccentColour,
                  minimumSize: Size(130, 38),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: tertiary,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
            backgroundColor: secondary,
            elevation: 1,
          );
        }
    );
  }

  void showBox({required BuildContext context, required AlertDialog Function(BuildContext context) builder}) {}
}

