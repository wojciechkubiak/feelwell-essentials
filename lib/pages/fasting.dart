import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:feelwell_essentials/lang/locale_keys.g.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../components/components.dart';

class Fasting extends StatefulWidget {
  final FastingModel fastingData;

  const Fasting({super.key, required this.fastingData});

  @override
  State<Fasting> createState() => _FastingState();
}

class _FastingState extends State<Fasting> {
  Timer? timer;
  bool isFasting = false;
  String fastingInformation = '';
  double timePassed = 0;

  String formatNumber({required int numb}) {
    return numb > 9 ? '$numb' : '0$numb';
  }

  void compareDates() {
    DateTime now = DateTime.now();
    int diff = widget.fastingData.end.difference(now).inSeconds;
    int startDiff = widget.fastingData.start.difference(now).inSeconds;
    bool isAfterStart = now.isAfter(widget.fastingData.start);
    int h, m, s;

    h = diff ~/ 3600;
    m = ((diff - h * 3600)) ~/ 60;
    s = diff - (h * 3600) - (m * 60);

    String result =
        "${formatNumber(numb: h)}:${formatNumber(numb: m)}:${formatNumber(numb: s)}";

    bool isFastingTime = isAfterStart && diff >= 0;

    setState(
      () {
        isFasting = isFastingTime;
        fastingInformation =
            isFastingTime ? result : LocaleKeys.fasting_youCanEat.tr();
        timePassed = startDiff.toDouble() * -1;
      },
    );
  }

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => compareDates(),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget textXL({required String text, double fontSize = 52}) {
    return Text(
      text,
      style: GoogleFonts.bebasNeue(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget header() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        LocaleKeys.fasting_header,
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ).tr(),
    );
  }

  Widget description() {
    return Text(
      LocaleKeys.fasting_description,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.start,
    ).tr();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    header(),
                    description(),
                  ],
                ),
              ),
              if (fastingInformation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Gauge(
                    valueAnnotation: fastingInformation,
                    maxValue: widget.fastingData.durationInSeconds,
                    value: timePassed,
                  ),
                ),
              if (fastingInformation.isEmpty)
                const SizedBox(
                  height: 300,
                  child: Loader(color: Colors.white),
                ),
              textXL(
                text: LocaleKeys.fasting_start.tr(),
                fontSize: 22,
              ),
              textXL(text: widget.fastingData.formattedStart),
              textXL(
                text: LocaleKeys.fasting_end.tr(),
                fontSize: 22,
              ),
              textXL(text: widget.fastingData.formattedEnd),
            ],
          ),
        ),
      ),
    );
  }
}
