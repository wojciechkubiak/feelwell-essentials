import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScaffoldWrapper extends StatelessWidget {
  final String title;
  final Widget body;

  const ScaffoldWrapper({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: body,
    );
  }
}
