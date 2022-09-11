import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Gauge extends StatelessWidget {
  final String valueAnnotation;
  final double maxValue;
  final double value;

  const Gauge({
    Key? key,
    required this.valueAnnotation,
    required this.maxValue,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
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
              widget: Text(
                valueAnnotation,
                style: GoogleFonts.bebasNeue(
                  fontSize: 58,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              angle: 90,
            )
          ])
    ]);
  }
}
