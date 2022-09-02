import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function(BuildContext context, Widget route) onPressed;
  final Widget route;

  const NavigationButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 12,
          ),
          elevation: 15,
        ),
        onPressed: () => onPressed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
            Icon(
              icon,
              size: 42,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
