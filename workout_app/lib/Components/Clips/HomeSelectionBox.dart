import 'package:flutter/material.dart';

class HomeSelectionBoxClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    Path path = Path();
    path.lineTo(0,size.height);

    path.quadraticBezierTo(size.width/3.8, size.height/1.8, size.width/1.93, size.height*0.45);
    path.quadraticBezierTo(size.width*0.7, size.height*0.34, size.width, 0);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return true;
  }
}
