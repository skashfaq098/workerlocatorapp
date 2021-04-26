import 'package:flutter/material.dart';

class CustomClipTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.3, 50),
      radius: 250,
    ));
    return path;
    // throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
    // throw UnimplementedError();
  }
}
