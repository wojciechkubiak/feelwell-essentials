import 'dart:async';
import 'package:feelwell_essentials/models/settings.dart';
import 'package:feelwell_essentials/services/storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DataSettingsService {
  Future<SettingsModel> initSettings({required Database db});
  Future<SettingsModel> getSettings();
}

class SettingsService extends DataSettingsService {
  final SettingsModel _defaultSettings = SettingsModel(
    waterCapacity: 250,
    waterToDrink: 2000,
    fastingLength: 14,
    fastingStartHour: 8,
    fastingStartMinutes: 30,
    exerciseLength: 1800,
    meditationLength: 1800,
  );

  @override
  Future<SettingsModel> getSettings() async {
    try {
      StorageService storageService = StorageService();
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> settingsList = [];

      settingsList =
          await db.rawQuery("SELECT * FROM settings ORDER BY id DESC LIMIT 1");

      if (settingsList.isNotEmpty) {
        SettingsModel settings = SettingsModel.fromJson(settingsList[0]);
        settings.isProper = true;
        return settings;
      }

      return initSettings(db: db);
    } catch (e) {
      print(e.toString());
      return _defaultSettings;
    }
  }

  @override
  Future<SettingsModel> initSettings({required Database db}) async {
    SettingsModel settings = _defaultSettings;

    try {
      StorageService storageService = StorageService();
      final db = await storageService.getDatabase();

      SettingsModel resultSettings =
          await db.insert('settings', _defaultSettings.toJson()).then(
        (value) {
          print('INSERTED ${_defaultSettings.toJson()}');
          settings.isProper = true;
          return settings;
        },
      );

      return resultSettings;
    } catch (e) {
      print(e.toString());
      return _defaultSettings;
    }
  }
}
