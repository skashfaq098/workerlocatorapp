import 'package:flutter/material.dart';

class CustomClipOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(
      Rect.fromCircle(center: Offset(size.width, 50), radius: 150),
    );
    return path;
    // TODO: implement getClip
    // throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
    // throw UnimplementedError();
  }
}
