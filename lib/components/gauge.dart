import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'components.dart';

class Gauge extends StatelessWidget {
  final String valueAnnotation;
  final double maxValue;
  final double value;
  final bool isNavigation;
  final bool? isRunning;
  final void Function()? onPause;
  final void Function()? onPlay;
  final void Function()? onStop;

  const Gauge({
    Key? key,
    required this.valueAnnotation,
    required this.maxValue,
    required this.value,
    this.isNavigation = false,
    this.isRunning,
    this.onPause,
    this.onPlay,
    this.onStop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget navigationButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TransparentButton(
            padding: EdgeInsets.zero,
            body: const Icon(
              Icons.stop,
              color: Colors.white,
              size: 52,
            ),
            onPressed: onStop,
          ),
          if (isRunning!)
            TransparentButton(
              padding: EdgeInsets.zero,
              body: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 102,
              ),
              onPressed: onPause,
            ),
          if (!isRunning!)
            TransparentButton(
              padding: EdgeInsets.zero,
              body: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 102,
              ),
              onPressed: onPlay,
            ),
        ],
      );
    }

    return Column(
      children: [
        SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: maxValue,
              showLabels: false,
              showAxisLine: false,
              ranges: [
                GaugeRange(
                  startValue: 0,
                  endValue: maxValue,
                  color: Colors.white,
                  startWidth: 30,
                  endWidth: 30,
                ),
              ],
              pointers: [
                MarkerPointer(
                  value: value,
                  color: Colors.green,
                  borderColor: Colors.white,
                  borderWidth: 3,
                  elevation: 20,
                  markerHeight: 30,
                  markerWidth: 30,
                )
              ],
              annotations: [
                GaugeAnnotation(
                  verticalAlignment: GaugeAlignment.center,
                  horizontalAlignment: GaugeAlignment.center,
                  widget: Center(
                    child: Text(
                      valueAnnotation,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 58,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  angle: 90,
                )
              ])
        ]),
        if (isNavigation) navigationButtons(),
      ],
    );
  }
}
