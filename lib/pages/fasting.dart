import 'dart:async';

import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/models/fasting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/home/home_bloc.dart';
import '../components/loader.dart';

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

  String formatNumber({required int numb}) {
    return numb > 9 ? '$numb' : '0$numb';
  }

  void compareDates() {
    DateTime now = DateTime.now();
    int diff = widget.fastingData.end.difference(now).inSeconds;
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
        fastingInformation = isFastingTime ? result : 'MOŻESZ JEŚĆ';
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

  Widget textXL({required String text, double fontSize = 72}) {
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

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      onBack: () => BlocProvider.of<HomeBloc>(context).add(
        HomeShowPageBack(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textXL(
              text: 'POZOSTAŁO:',
              fontSize: 22,
            ),
            if (fastingInformation.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: textXL(
                  text: fastingInformation,
                  fontSize: 76,
                ),
              ),
            if (fastingInformation.isEmpty) const Loader(color: Colors.white),
            textXL(
              text: 'POCZĄTEK:',
              fontSize: 22,
            ),
            textXL(text: widget.fastingData.formattedStart),
            textXL(
              text: 'KONIEC:',
              fontSize: 22,
            ),
            textXL(text: widget.fastingData.formattedEnd),
          ],
        ),
      ),
    );
  }
}
