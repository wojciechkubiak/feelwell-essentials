import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/loading.json',
          ),
          Text(
            'Feelwell Essentials',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              fontSize: 62,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
