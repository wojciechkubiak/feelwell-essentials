import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  final void Function(BuildContext context, Widget route) onPressed;
  final Widget route;
  final bool isFilled;
  final IconData? icon;

  const NavigationButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.route,
    this.isFilled = false,
    this.icon,
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
          primary: isFilled ? Colors.green : Colors.white,
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
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: isFilled ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (icon is IconData)
              Icon(
                icon,
                size: 52,
                color: isFilled ? Colors.white : Colors.green,
              )
          ],
        ),
      ),
    );
  }
}
