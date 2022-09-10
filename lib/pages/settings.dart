import 'package:feelwell_essentials/components/button.dart';
import 'package:feelwell_essentials/services/water.dart';
import 'package:flutter/material.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/models/settings.dart';
import 'package:feelwell_essentials/services/settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/home/home_bloc.dart';

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

  TextEditingController? waterToDrinkController;
  TextEditingController? fastingStart;
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
    );

    return newTime;
  }

  void loadSettings() async {
    SettingsModel settings = widget.settings;
    waterToDrinkController =
        TextEditingController(text: settings.waterToDrink.toString());
    fastingStart = TextEditingController(
      text: '${settings.fastingStartHour}:${settings.fastingStartMinutes}',
    );
    exerciseLengthController = TextEditingController(
      text: (settings.exerciseLength / 60).toStringAsFixed(0),
    );
    meditationLengthController = TextEditingController(
      text: (settings.meditationLength / 60).toStringAsFixed(0),
    );

    setState(() {
      settingsCopy = settings;
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
            '$header :',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
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
                  ),
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
              '$header :',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
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
              labelText: label,
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
              hintText: 'Wpisz oczekiwaną wartość',
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
              '$header :',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
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
        'USTAWIENIA',
        style: GoogleFonts.poppins(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel settings = settingsCopy;

    return ScaffoldWrapper(
      onBack: () => BlocProvider.of<HomeBloc>(context).add(
        HomeShowPageBack(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              header(),
              tilePicker(
                header: 'Rozmiar szklanki (ml)',
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
                header: 'Dzienna dawka wody (ml)',
                label: 'Ilość',
                controller: waterToDrinkController!,
              ),
              tilePicker(
                header: 'Długość postu',
                tileOptions: ['12', '14', '16'],
                currentOption: settings.fastingLength.toString(),
                onPressed: (option) {
                  settings.fastingLength = int.tryParse(option) ?? 12;

                  setState(() {
                    settingsCopy = settings;
                  });
                },
              ),
              hourPicker(
                header: 'Początek postu',
                settingsData: settingsCopy,
                hourKey: 'fastingStartHour',
                minutesKey: 'fastingStartMinutes',
              ),
              inputField(
                header: 'Długość ćwiczenia (min)',
                label: 'Długość',
                controller: exerciseLengthController!,
              ),
              inputField(
                header: 'Długość medytacji (min)',
                label: 'Długość',
                controller: meditationLengthController!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Button(
                  text: 'Zatwierdź',
                  onPressed: () async {
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

                    await settingsService.updateSettings(
                      settingsModel: settings,
                    );
                    await waterService.updateWaterToDrink(
                      toDrink: settings.waterToDrink,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
