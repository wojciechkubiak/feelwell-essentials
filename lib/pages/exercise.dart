import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:feelwell_essentials/components/components.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lang/locale_keys.g.dart';
import '../models/models.dart';
import '../services/services.dart';

class Exercise extends StatefulWidget {
  final ExerciseModel exerciseData;

  const Exercise({super.key, required this.exerciseData});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  final ExerciseService exerciseService = ExerciseService();
  late int timeLeft;
  Timer? timer;
  bool isDialog = false;
  bool isCompleted = false;
  bool isRunning = false;

  void pauseTimer() {
    if (mounted) setState(() => isRunning = false);
    timer?.cancel();
  }

  void stopTimer() {
    if (mounted) setState(() => isRunning = false);
    timer?.cancel();
    setState(() => timeLeft = widget.exerciseData.duration);
  }

  void runTimer() {
    if (timeLeft.floor() == 0) {
      stopTimer();
      exerciseService.changeExerciseStatusToCompleted();
      if (mounted) {
        setState(() {
          timeLeft = widget.exerciseData.duration;
          isCompleted = true;
        });
      }
    } else {
      if (mounted) setState(() => timeLeft = timeLeft - 1);
    }
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        timeLeft = widget.exerciseData.duration;
        isCompleted = widget.exerciseData.isCompleted == 0 ? false : true;
      });
    }
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

  Widget header() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        LocaleKeys.exercise_header,
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ).tr(namedArgs: {
        'isDone': isCompleted ? '(${LocaleKeys.exercise_headerDone.tr()})' : ''
      }),
    );
  }

  Widget description() {
    return Text(
      LocaleKeys.exercise_description,
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
      isDialog: widget.exerciseData.duration != timeLeft,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    header(),
                    description(),
                  ],
                ),
              ),
              Gauge(
                valueAnnotation: printDuration(seconds: timeLeft),
                maxValue: widget.exerciseData.duration.toDouble(),
                value: timeLeft.toDouble(),
                isNavigation: true,
                isRunning: isRunning,
                onPause: pauseTimer,
                onPlay: () {
                  if (mounted) setState(() => isRunning = true);

                  timer = Timer.periodic(
                    const Duration(seconds: 1),
                    (Timer t) => runTimer(),
                  );
                },
                onStop: stopTimer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
