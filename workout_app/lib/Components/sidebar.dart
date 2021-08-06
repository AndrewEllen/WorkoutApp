import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

class CustomSideBar extends StatelessWidget {
  CustomSideBar({required this.sidebaraccentcolour, required this.sidebarcolour});
  final Color sidebaraccentcolour, sidebarcolour;
  final currentUser = GetIt.instance<SupabaseClient>().auth.user();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: sidebarcolour,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          toolbarHeight: 100,
          title: Center(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left:60,top:0,bottom:0),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(45),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right:0,top:60),
                  child: Text(
                    'User: ${currentUser?.email}',
                    style: TextStyle(
                      fontSize: 13,
                      color: sidebaraccentcolour,
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
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
    );
  }
}

