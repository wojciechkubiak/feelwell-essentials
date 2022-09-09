import 'dart:async';
import 'package:feelwell_essentials/models/settings.dart';
import 'package:feelwell_essentials/services/storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DataSettingsService {
  Future<SettingsModel?> initSettings();
  Future<SettingsModel?> getSettings();
  Future<bool> updateSettings({required SettingsModel settingsModel});
}

class SettingsService extends DataSettingsService {
  final SettingsModel _defaultSettings = SettingsModel(
    id: 1,
    waterCapacity: 250,
    waterToDrink: 2000,
    fastingLength: 14,
    fastingStartHour: 8,
    fastingStartMinutes: 30,
    exerciseLength: 1800,
    meditationLength: 1800,
  );

  @override
  Future<SettingsModel?> getSettings() async {
    try {
      StorageService storageService = StorageService();
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> settingsList = [];

      settingsList =
          await db.rawQuery("SELECT * FROM settings ORDER BY id DESC LIMIT 1");

      if (settingsList.isNotEmpty) {
        SettingsModel settings = SettingsModel.fromJson(settingsList[0]);
        return settings;
      }

      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<SettingsModel?> initSettings() async {
    SettingsModel settings = _defaultSettings;
    try {
      SettingsModel? existingSettings = await getSettings();

      if (existingSettings is SettingsModel) {
        print(4);
        return existingSettings;
      }

      print(3);
      StorageService storageService = StorageService();
      final db = await storageService.getDatabase();

      SettingsModel resultSettings =
          await db.insert('settings', _defaultSettings.toJson()).then(
        (value) {
          print('INSERTED ${_defaultSettings.toJson()}');
          return settings;
        },
      );

      return resultSettings;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> updateSettings({required SettingsModel settingsModel}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();

      SettingsModel? currentSettings = await getSettings();
      if (currentSettings is SettingsModel) {
        int currentId = currentSettings.id;

        int count = await db.rawUpdate(
          '''UPDATE settings SET waterCapacity = ?, 
        waterToDrink = ?, 
        fastingLength = ?, 
        fastingStartHour = ?, 
        fastingStartMinutes = ?, 
        exerciseLength = ?, 
        meditationLength = ? 
        WHERE id = ?''',
          [
            settingsModel.waterCapacity,
            settingsModel.waterToDrink,
            settingsModel.fastingLength,
            settingsModel.fastingStartHour,
            settingsModel.fastingStartMinutes,
            settingsModel.exerciseLength,
            settingsModel.meditationLength,
            currentId
          ],
        );
        return count > 0;
      }

      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
