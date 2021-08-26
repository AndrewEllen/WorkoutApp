import 'package:flutter/material.dart';

class HomeAppBarClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    
    Path path = Path();
    path.lineTo(0,size.height);

    path.quadraticBezierTo(size.width/2, size.height - 80, size.width, size.height);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return false;
  }
}

class HomeAppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.lineTo(0,size.height);

    path.quadraticBezierTo(size.width/2, size.height - 80, size.width, size.height);

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawShadow(path, Colors.black, 4, true);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
