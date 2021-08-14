import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import '../constants.dart';
import '../router.dart';
import '../screens/index.dart';

class CustomSideBar extends StatefulWidget {
  CustomSideBar(
      {required this.sidebaraccentcolour, required this.sidebarcolour});
  final Color sidebaraccentcolour, sidebarcolour;

  @override
  _CustomSideBarState createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  late final avatar;
  late final username;
  final currentUser = supabase.auth.user();

  var _loading = false;

  void initState() {
    _getProfile(currentUser!.id);
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
    }
    if (response.data != null) {
      username = response.data!['username'] as String;
      avatar = response.data!['avatar_url'] as String;
    } else {
      avatar = "https://i.imgur.com/yKV9vpH.png";
      username = currentUser?.email;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: widget.sidebarcolour,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          toolbarHeight: 100,
          title: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          FadeRouter(
                            routeName: '/usersettings',
                            screen: UserSettings(),
                          ));
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(45),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(_loading
                              ? 'https://i.imgur.com/yKV9vpH.png'
                              : avatar),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(right: 0, top: 60),
                    child: Text(
                      'User: ${_loading ? currentUser?.email : username}',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.sidebaraccentcolour,
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
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
    );
  }
}
