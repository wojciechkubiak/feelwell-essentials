import 'package:flutter/material.dart';
import 'package:feelwell_essentials/components/error_info.dart';
import 'package:feelwell_essentials/components/loader.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/models/settings.dart';
import 'package:feelwell_essentials/services/settings.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsModel? settings;

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
    SettingsService settingsService = SettingsService();
    SettingsModel settingsData = await settingsService.getSettings();
    waterToDrinkController =
        TextEditingController(text: settingsData.waterToDrink.toString());
    fastingStart = TextEditingController(
      text:
          '${settingsData.fastingStartHour}:${settingsData.fastingStartMinutes}',
    );
    exerciseLengthController =
        TextEditingController(text: settingsData.exerciseLength.toString());
    meditationLengthController =
        TextEditingController(text: settingsData.meditationLength.toString());

    setState(() {
      settings = settingsData;
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
              fontSize: 24,
              color: Colors.black87,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
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
                    primary:
                        currentOption == option ? Colors.green : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    elevation: 15,
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
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          TextField(
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              hintText: 'Enter a search term',
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
                fontSize: 24,
                color: Colors.black87,
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
                  settings = SettingsModel.fromJson(settingsJson);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
              child: Text(
                '${settingsJson[hourKey]}:${settingsJson[minutesKey]}',
                style: GoogleFonts.bebasNeue(
                  fontSize: 72,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsBody(SettingsModel? settings) {
    if (settings is SettingsModel) {
      SettingsModel settingsCopy = settings;

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              tilePicker(
                header: 'Glass size (ml)',
                tileOptions: ['250', '300', '330'],
                currentOption: settingsCopy.waterCapacity.toString(),
                onPressed: (option) {
                  settingsCopy.waterCapacity = int.tryParse(option) ?? 250;

                  setState(() {
                    settings = settingsCopy;
                  });
                },
              ),
              inputField(
                header: 'Daily water (ml)',
                label: 'Enter your water',
                controller: waterToDrinkController!,
              ),
              tilePicker(
                header: 'Fasting',
                tileOptions: ['12', '14', '16'],
                currentOption: settingsCopy.fastingLength.toString(),
                onPressed: (option) {
                  settingsCopy.fastingLength = int.tryParse(option) ?? 12;

                  setState(() {
                    settings = settingsCopy;
                  });
                },
              ),
              hourPicker(
                header: 'Fasting start',
                settingsData: settingsCopy,
                hourKey: 'fastingStartHour',
                minutesKey: 'fastingStartMinutes',
              ),
              inputField(
                header: 'Exercise length (min)',
                label: 'Enter your length',
                controller: exerciseLengthController!,
              ),
              inputField(
                header: 'Meditation length (min)',
                label: 'Enter your length',
                controller: meditationLengthController!,
              ),
            ],
          ),
        ),
      );
    }

    return const Center(child: Loader());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      title: 'Settings',
      body: settingsBody(settings),
    );
  }
}
