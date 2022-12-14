import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool isFilled;
  final IconData? icon;

  const NavigationButton({
    Key? key,
    required this.onPressed,
    required this.text,
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
          backgroundColor: isFilled ? Colors.green : Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 12,
          ),
          elevation: 15,
        ),
        onPressed: onPressed,
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
            ).tr(),
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
