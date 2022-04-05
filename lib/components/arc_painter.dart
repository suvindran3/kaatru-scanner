import 'dart:math';
import 'package:flutter/material.dart';


class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const rect =  Rect.fromLTRB(-100, -200, 500, 150);
    const startAngle = pi;
    const sweepAngle = -pi;
    const useCenter = true;
    final paint = Paint()
      ..color =  Colors.brown

      ..strokeWidth = 4;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
