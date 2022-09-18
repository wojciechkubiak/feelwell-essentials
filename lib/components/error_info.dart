import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lang/locale_keys.g.dart';

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        LocaleKeys.error_description.tr(),
        textAlign: TextAlign.center,
        style: GoogleFonts.bebasNeue(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
