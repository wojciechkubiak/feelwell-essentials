import 'package:feelwell_essentials/components/loader.dart';
import 'package:feelwell_essentials/components/scaffold_wrapper.dart';
import 'package:feelwell_essentials/models/settings.dart';
import 'package:feelwell_essentials/services/settings.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsModel? settings;

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  void loadSettings() async {
    SettingsService settingsService = SettingsService();
    SettingsModel settingsData = await settingsService.getSettings();

    setState(() {
      settings = settingsData;
    });
  }

  Widget settingsBody(SettingsModel? settings) {
    if (settings is SettingsModel) {
      return ElevatedButton(
        child: Text(settings.exerciseLength.toString()),
        onPressed: () {
          // Navigate to second route when tapped.
        },
      );
    }

    return const Loader();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      title: 'Settings',
      body: Center(
        child: settingsBody(settings),
      ),
    );
  }
}
