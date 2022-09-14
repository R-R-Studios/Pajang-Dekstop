import 'package:beben_pos_desktop/core/fireship/fireship_palette.dart';
import 'package:flutter/material.dart';

class Component {

  static Text text(
    String content,
    {Color colors = Colors.black54,
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.normal,
    int maxLines = 2,
    TextAlign textAlign = TextAlign.start}) {
    return Text(
      content,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        color: colors,
        // fontFamily: Constant.poppinsRegular,
        fontSize: fontSize.toDouble(),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Widget divider({int padding = 8}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        color: FireshipPalette.grey,
        height: 1,
      ),
    );
  }
}