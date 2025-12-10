import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
Text text(String text, Color textColor, double fontSize,
    {FontWeight fontWeight = FontWeight.normal}) {
  return Text(
    text,
    style: GoogleFonts.openSans(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    ),
  );
}
