// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyling {
  static Widget textFieldTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          color: const Color(0xFF858597),
          fontSize: 14,
        ),
      ),
    );
  }
}
