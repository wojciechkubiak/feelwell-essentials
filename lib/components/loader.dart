import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const double _kSize = 60;

class Loader extends StatelessWidget {
  final Color color;

  const Loader({
    Key? key,
    this.color = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.stretchedDots(
      color: color,
      size: _kSize,
    );
  }
}
