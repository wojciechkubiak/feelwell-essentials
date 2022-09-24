import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:feelwell_essentials/components/components.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:feelwell_essentials/services/meditation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lang/locale_keys.g.dart';
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
  bool isCompleted = false;
  bool isRunning = false;
  bool isSoundEnabled = true;
  bool isSFXRunning = false;
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer sfxPlayer = AudioPlayer();

  @override
  void initState() {
    handleSource();
    musicPlayer.setVolume(1);
    if (mounted) {
      setState(() {
        timeLeft = widget.meditationData.duration;
        isCompleted = widget.meditationData.isCompleted == 0 ? false : true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    musicPlayer.dispose();
    sfxPlayer.dispose();
    super.dispose();
  }

  Future<void> handleSource() async {
    await musicPlayer.setSource(AssetSource("sound/music.mp3"));
    await sfxPlayer.setSource(AssetSource("sound/countdown.mp3"));
  }

  Future<void> onSoundEnabledChange() async {
    if (isSoundEnabled) {
      if (isRunning) {
        pauseMusic();
      }
      setState(() => isSoundEnabled = false);
    } else {
      if (isRunning) {
        play();
      }
      setState(() => isSoundEnabled = true);
    }
  }

  Future<void> play() async {
    await musicPlayer.resume();
  }

  Future<void> playSFX() async {
    await sfxPlayer.resume();
  }

  Future<void> stop() async {
    handleIsSFXPlaying(isPlaying: false);
    await musicPlayer.stop();
    await sfxPlayer.stop();
  }

  Future<void> pauseMusic() async {
    await musicPlayer.pause();
  }

  Future<void> pauseSFX() async {
    handleIsSFXPlaying(isPlaying: false);
    await sfxPlayer.pause();
  }

  void pauseTimer() {
    if (isSoundEnabled) pauseMusic();

    if (mounted) setState(() => isRunning = false);
    timer?.cancel();
  }

  void stopTimer() {
    if (isSoundEnabled) {
      stop();
    }
    if (mounted) setState(() => isRunning = false);
    timer?.cancel();
    handleIsSFXPlaying(isPlaying: false);
    setState(() => timeLeft = widget.meditationData.duration);
  }

  void handleIsSFXPlaying({required bool isPlaying}) {
    setState(() => isSFXRunning = isPlaying);
  }

  void runTimer() {
    if (timeLeft.floor() == 0) {
      stopTimer();
      meditationService.changeMeditationStatusToCompleted();
      if (mounted) {
        setState(() {
          timeLeft = widget.meditationData.duration;
          isCompleted = true;
        });
      }
    } else {
      if (timeLeft.floor() <= 11 && !isSFXRunning) {
        handleIsSFXPlaying(isPlaying: true);
        playSFX();
      }
      if (mounted) setState(() => timeLeft = timeLeft - 1);
    }
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
        LocaleKeys.meditation_header,
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ).tr(namedArgs: {
        'isDone':
            isCompleted ? '(${LocaleKeys.meditation_headerDone.tr()})' : ''
      }),
    );
  }

  Widget description() {
    return Text(
      LocaleKeys.meditation_description,
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
      isDialog: widget.meditationData.duration != timeLeft,
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
                maxValue: widget.meditationData.duration.toDouble(),
                value: timeLeft.toDouble(),
                isNavigation: true,
                isRunning: isRunning,
                onPause: pauseTimer,
                isSound: true,
                isSoundEnabled: isSoundEnabled,
                isPauseDisabled: isSFXRunning,
                onSoundEnabledChange: onSoundEnabledChange,
                onPlay: () {
                  if (isSoundEnabled) play();

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
