import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final Widget body;
  final void Function()? onPressed;
  final Color backgroundColor;
  final EdgeInsets padding;

  const TransparentButton({
    Key? key,
    required this.body,
    required this.onPressed,
    this.backgroundColor = Colors.green,
    this.padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        elevation: 0,
      ),
      onPressed: onPressed,
      child: body,
    );
  }
}
