import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class Buttons {
  static Widget customButton(String text, double width, onPress,
      [bool primary = true]) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        fixedSize: Size(width, 60),
        primary: primary ? buttonPrimaryColor : buttonSecondColor,
        elevation: 2,
      ),
      child: Text(text,
          style: GoogleFonts.openSans(fontSize: 15, color: Colors.white)),
    );
  }
}
