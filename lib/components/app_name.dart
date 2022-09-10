import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppName extends StatelessWidget {
  final Color color;
  final double fontSize;

  const AppName({
    Key? key,
    this.color = Colors.white,
    this.fontSize = 62,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Feelwell Essentials',
      textAlign: TextAlign.center,
      style: GoogleFonts.bebasNeue(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
