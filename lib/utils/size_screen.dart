import 'dart:ui';

class SizeScreen {
  static late double pixelRatio;

  //Size in physical pixels
  static late Size physicalScreenSize;
  static late double physicalWidth;
  static late double physicalHeight;

//Size in logical pixels
  static late Size logicalScreenSize;
  static late double logicalWidth;
  static late double logicalHeight;

//Padding in physical pixels
  static late WindowPadding padding;

//Safe area paddings in logical pixels
  static late double paddingLeft;
  static late double paddingRight;
  static late double paddingTop;
  static late double paddingBottom;

//Safe area in logical pixels
  static late double safeWidth;
  static late double safeHeight;

  init(){
    pixelRatio = window.devicePixelRatio;

    physicalScreenSize = window.physicalSize;
    physicalWidth = physicalScreenSize.width;
    physicalHeight = physicalScreenSize.height;

    logicalScreenSize = window.physicalSize / pixelRatio;
    logicalWidth = logicalScreenSize.width;
    logicalHeight = logicalScreenSize.height;

    padding = window.padding;

    paddingLeft = window.padding.left / window.devicePixelRatio;
    paddingRight = window.padding.right / window.devicePixelRatio;
    paddingTop = window.padding.top / window.devicePixelRatio;
    paddingBottom = window.padding.bottom / window.devicePixelRatio;

    safeWidth = logicalWidth - paddingLeft - paddingRight;
    safeHeight = logicalHeight - paddingTop - paddingBottom;

    // safeWidth = logicalWidth;
    // safeHeight = logicalHeight;
  }
}