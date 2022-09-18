import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lang/locale_keys.g.dart';

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
      LocaleKeys.appName.tr(),
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
