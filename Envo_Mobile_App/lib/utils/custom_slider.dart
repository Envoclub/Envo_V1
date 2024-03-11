import 'dart:ui' as ui;

import 'package:envo_mobile/utils/meta_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderThumbImage extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(20, 20);
  }

  @override
  void paint(PaintingContext context, ui.Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required ui.TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required ui.Size sizeWithOverflow}) {
    // TODO: implement paint
    final canvas = context.canvas;

    Offset imageOffset = Offset(
      center.dx - (20 / 2),
      center.dy - (10),
    );
    final icon = Icons.directions_walk_rounded;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
            fontSize: 20.0, fontFamily: icon.fontFamily, color: MetaColors.secondaryColor));
    textPainter.layout();
    textPainter.paint(canvas, imageOffset);
  }
}
