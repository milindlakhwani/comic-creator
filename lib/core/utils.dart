import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:comic_creator/core/globals/my_colors.dart';
import 'package:comic_creator/core/globals/my_fonts.dart';

// Function to show toast message
void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

// TextFormField decoration
InputDecoration textboxDecoration(String text) {
  return InputDecoration(
    filled: true,
    hintText: text,
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: iconColor),
      borderRadius: BorderRadius.circular(7.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: kBlue),
      borderRadius: BorderRadius.circular(7.5),
    ),
    hintStyle: MyFonts.light.setColor(textColor.withOpacity(0.7)).size(15),
    fillColor: const Color.fromRGBO(39, 41, 45, 1),
    border: InputBorder.none,
    contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: iconColor),
      borderRadius: BorderRadius.circular(7.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: iconColor),
      borderRadius: BorderRadius.circular(7.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: kBlue),
      borderRadius: BorderRadius.circular(7.5),
    ),
    errorStyle: const TextStyle(height: 0, color: Colors.transparent),
  );
}
