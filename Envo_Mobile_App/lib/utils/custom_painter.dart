import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:math' as math;

class CurvePainter extends CustomPainter {
  CurvePainter(this.svg);

  final PictureInfo svg;
  @override
  void paint(Canvas canvas, Size size) {
    double x = 0;
    double sizewidth = 0;
    canvas.translate(0, size.height);
    for (var i = 0; i < 30; i += 1) {
      int j = 0;
      sizewidth += 10;
      x = 10;

      // canvas.rotate((0) * (math.pi / 180));
      if (i <= 15) {
        log(math.tan((i) * (math.pi / 180)).toString());
        canvas.rotate(math.tan((i) * (math.pi / 180)));
      } else {
        sizewidth = 0;
        log("Hereeee");
        canvas.rotate(math.tan((-i) * (math.pi / 180)));
      }
      canvas.drawPicture(svg.picture);

      canvas.translate(x, -30);
    }

    // canvas.drawLine(Offset(10, 10), Offset(10, 30), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
