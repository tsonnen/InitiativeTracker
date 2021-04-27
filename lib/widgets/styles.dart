import 'package:flutter/material.dart';

class Styles {
  static InputDecoration textFieldDecoration(String labelText,
      {Color? fillColor}) {
    return InputDecoration(
        border: InputBorder.none,
        labelText: labelText,
        fillColor: fillColor,
        filled: fillColor != null);
  }
}
