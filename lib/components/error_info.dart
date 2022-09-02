import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Something went wrong and your settings data could not get loaded. Try to clean your app storage or to reinstall your application',
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
