import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../lang/locale_keys.g.dart';
import '../blocs/home/home_bloc.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../services/services.dart';

class Settings extends StatefulWidget {
  final SettingsModel settings;

  const Settings({super.key, required this.settings});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SettingsModel settingsCopy;
  SettingsService settingsService = SettingsService();
  WaterService waterService = WaterService();
  ExerciseService exerciseService = ExerciseService();
  MeditationService meditationService = MeditationService();

  bool isError = false;

  TextEditingController? waterToDrinkController;
  TextEditingController? exerciseLengthController;
  TextEditingController? meditationLengthController;

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<TimeOfDay?> _selectTime({
    required int hours,
    required int minutes,
  }) async {
    TimeOfDay initTime = TimeOfDay(hour: hours, minute: minutes);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: initTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.green,
                onSurface: Colors.green,
              ),
              buttonTheme: const ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.green,
                ),
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.green,
              ),
            ),
            child: childWidget!,
          ),
        );
      },
    );

    return newTime;
  }

  void loadSettings() async {
    waterToDrinkController = TextEditingController(
      text: widget.settings.waterToDrink.toString(),
    );
    exerciseLengthController = TextEditingController(
      text: (widget.settings.exerciseLength / 60).toStringAsFixed(0),
    );
    meditationLengthController = TextEditingController(
      text: (widget.settings.meditationLength / 60).toStringAsFixed(0),
    );

    setState(() {
      settingsCopy = widget.settings;
    });
  }

  Widget tilePicker({
    required String header,
    required List<String> tileOptions,
    required String currentOption,
    required void Function(String option) onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
      child: Column(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ).tr(),
          const SizedBox(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: tileOptions.map(
              (option) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    backgroundColor:
                        currentOption == option ? Colors.green : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    elevation: 8,
                  ),
                  onPressed: () => onPressed(option),
                  child: Text(
                    option,
                    style: TextStyle(
                      color:
                          currentOption != option ? Colors.green : Colors.white,
                    ),
                  ).tr(),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget inputField({
    required String header,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              header,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ).tr(),
          ),
          TextField(
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              labelText: label.tr(),
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              hintText: LocaleKeys.settings_inputExpectedValue.tr(),
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget hourPicker({
    required SettingsModel settingsData,
    required String hourKey,
    required String minutesKey,
    String? header,
  }) {
    Map<String, dynamic> settingsJson = settingsData.toJson();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
      child: Column(
        children: [
          if (header is String)
            Text(
              header,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ).tr(),
          GestureDetector(
            onTap: () async {
              TimeOfDay? newTime = await _selectTime(
                hours: settingsJson[hourKey],
                minutes: settingsJson[minutesKey],
              );

              if (newTime is TimeOfDay) {
                settingsJson[hourKey] = newTime.hour;
                settingsJson[minutesKey] = newTime.minute;

                setState(() {
                  settingsCopy = SettingsModel.fromJson(settingsJson);
                });
              }
            },
            child: Text(
              '${settingsJson[hourKey]}:${settingsJson[minutesKey]}',
              style: GoogleFonts.bebasNeue(
                fontSize: 72,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Text(
        LocaleKeys.settings_header,
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ).tr(),
    );
  }

  Widget error() {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 20.0),
      child: Text(
        LocaleKeys.settings_error,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white70,
          fontWeight: FontWeight.w200,
        ),
        textAlign: TextAlign.start,
      ).tr(),
    );
  }

  void goHomePage() {
    BlocProvider.of<HomeBloc>(context).add(
      HomeShowPageBack(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = settingsCopy;

    return ScaffoldWrapper(
      showSettings: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              header(),
              tilePicker(
                header: LocaleKeys.settings_glassSize,
                tileOptions: ['250', '300', '330'],
                currentOption: settings.glassSize.toString(),
                onPressed: (option) {
                  settings.glassSize = int.tryParse(option) ?? 250;

                  setState(() {
                    settingsCopy = settings;
                  });
                },
              ),
              inputField(
                header: LocaleKeys.settings_dailyWater,
                label: LocaleKeys.settings_qty,
                controller: waterToDrinkController!,
              ),
              tilePicker(
                header: LocaleKeys.settings_fastingLength,
                tileOptions: ['12', '14', '16'],
                currentOption: settings.fastingLength.toString(),
                onPressed: (option) {
                  settings.fastingLength = int.parse(option);

                  setState(() {
                    settingsCopy = settings;
                  });
                },
              ),
              hourPicker(
                header: LocaleKeys.settings_fastingStart,
                settingsData: settingsCopy,
                hourKey: 'fastingStartHour',
                minutesKey: 'fastingStartMinutes',
              ),
              inputField(
                header: LocaleKeys.settings_fastingLength,
                label: LocaleKeys.settings_length,
                controller: exerciseLengthController!,
              ),
              inputField(
                header: LocaleKeys.settings_meditationLength,
                label: LocaleKeys.settings_length,
                controller: meditationLengthController!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Button(
                  text: LocaleKeys.settings_submit.tr(),
                  onPressed: () async {
                    setState(() => isError = false);

                    int? waterToDrink =
                        int.tryParse(waterToDrinkController!.value.text);
                    if (waterToDrink is int) {
                      settings.waterToDrink = waterToDrink;
                    }

                    int? exerciseLength =
                        int.tryParse(exerciseLengthController!.value.text);
                    if (exerciseLength is int) {
                      settings.exerciseLength = exerciseLength * 60;
                    }

                    int? meditationLength =
                        int.tryParse(meditationLengthController!.value.text);
                    if (meditationLength is int) {
                      settings.meditationLength = meditationLength * 60;
                    }

                    bool isSettingsUpdated = await settingsService
                        .updateSettings(settingsModel: settings);
                    bool isWaterUpdated = await waterService.updateWaterToDrink(
                      toDrink: settings.waterToDrink,
                    );
                    bool isExerciseUpdated =
                        await exerciseService.updateExerciseDuration(
                      durationInSeconds: settings.exerciseLength,
                    );
                    bool isMeditationUpdated =
                        await meditationService.updateMeditationDuration(
                      durationInSeconds: settings.meditationLength,
                    );

                    if (isSettingsUpdated &&
                        isWaterUpdated &&
                        isExerciseUpdated &&
                        isMeditationUpdated) {
                      goHomePage();
                    } else {
                      setState(() => isError = true);
                    }
                  },
                ),
              ),
              if (isError) error(),
            ],
          ),
        ),
      ),
    );
  }
}
