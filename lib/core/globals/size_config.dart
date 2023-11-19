import 'package:flutter/material.dart';

// Class that is used to get device height and width anywhere, used to make app responsive
class SizeConfig {
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double horizontalBlockSize;
  static late double verticalBlockSize;
  static late double textScaleFactor;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    textScaleFactor = mediaQueryData.textScaleFactor;
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    horizontalBlockSize = screenWidth / 100;
    verticalBlockSize = screenHeight / 100;
  }
}
