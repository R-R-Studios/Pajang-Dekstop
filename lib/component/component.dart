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
}