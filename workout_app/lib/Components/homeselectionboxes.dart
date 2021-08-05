import 'package:flutter/material.dart';
import 'package:workout_app/constants.dart';
import '../router.dart';

class HomeSelectionBox extends StatelessWidget {
  HomeSelectionBox({
    required this.containertext, required this.containerroutename,
    required this.containerimageloc, required this.tintcolour,
    required this.containerroutewidget,
  });

  final String containertext, containerroutename, containerimageloc;
  final Widget containerroutewidget;
  final Color tintcolour;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          FadeRouter(
          routeName: containerroutename,
          screen: containerroutewidget,
          )
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
          bottom: 30,
          left: 20,
          right: 20,
        ),
        decoration: boxSelectionDecoration,
        height: boxSelectionHeight,
        width: boxSelectionWidth,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(tintcolour, BlendMode.screen),
                    image: ExactAssetImage(containerimageloc),
                  ),
                ),
              ),
            ),
            Center(
                child: Text(
              containertext,
              style: TextStyle(
                color: Colors.white,
                fontSize: 37,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 1,
                    color: Colors.black,
                    offset: Offset(1,5),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
