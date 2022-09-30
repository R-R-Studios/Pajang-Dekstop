import 'package:flutter/material.dart';

enum discountType {percent, nominal}
enum discountKind {product, transaction}
enum FeatureType  {transaction, vehicle, operatinal, employee, brands, category}
enum SaleTypeMenu {initial, shift, balance}

class Constant {
  static const avenirRegular = "avenir_regular";
  static const poppinsRegular = "poppins_regular";

  static const fontSizeLargeExtra = 20.0;
  static const fontSizeLarge = 15.0;
  static const fontSizeMedium = 13.0;
  static const fontSizeSmall = 11.0;
  static const paddingScreen = EdgeInsets.symmetric(horizontal: 15, vertical: 10);
  static const double paddingHorizontalScreen = 20.0;

}