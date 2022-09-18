import 'dart:async';

import 'package:feelwell_essentials/components/components.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/services/meditation.dart';
import 'package:flutter/material.dart';

import '../components/gauge.dart';
import '../models/models.dart';

class Meditation extends StatefulWidget {
  final MeditationModel meditationData;

  const Meditation({super.key, required this.meditationData});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  final MeditationService meditationService = MeditationService();
  late int timeLeft;
  Timer? timer;
  bool isDialog = false;

  void runTimer() {
    if (timeLeft.floor() == 0) {
      timer?.cancel();
      meditationService.changeMeditationStatusToCompleted();
      setState(() => timeLeft = widget.meditationData.duration);
    } else {
      setState(() => timeLeft = timeLeft - 1);
    }
  }

  @override
  void initState() {
    setState(() => timeLeft = widget.meditationData.duration);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String printDuration({required int seconds}) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      isDialog: isDialog,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Gauge(
                valueAnnotation: printDuration(seconds: timeLeft),
                maxValue: widget.meditationData.duration.toDouble(),
                value: timeLeft.toDouble(),
              ),
              Button(
                text: 'START',
                onPressed: () {
                  timer = Timer.periodic(
                    const Duration(seconds: 1),
                    (Timer t) => runTimer(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
