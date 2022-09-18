import 'dart:async';

import '../models/models.dart';
import '../services/services.dart';

abstract class DataMeditationService {
  Future<MeditationModel?> initMeditation();
  Future<MeditationModel?> getMeditation();
  Future<bool> changeMeditationStatusToCompleted();
  Future<bool> updateMeditationDuration({required int durationInSeconds});
}

class MeditationService extends DataMeditationService {
  final StorageService storageService = StorageService();
  final SettingsService settingsService = SettingsService();
  final int id = Ids.getRecordId();

  @override
  Future<MeditationModel?> initMeditation() async {
    final db = await storageService.getDatabase();

    SettingsModel? settings = await settingsService.getSettings();
    MeditationModel? meditation = await getMeditation();

    if (settings is SettingsModel && meditation is! MeditationModel) {
      MeditationModel defaultMeditation = MeditationModel(
        id: id,
        duration: settings.meditationLength,
        isCompleted: 0,
      );

      MeditationModel insertedMeditation =
          await db.insert('meditation', defaultMeditation.toJson()).then(
        (value) {
          print('MEDITATION INIT WITH: ${defaultMeditation.toJson()}');
          return defaultMeditation;
        },
      );

      return insertedMeditation;
    }

    return meditation;
  }

  @override
  Future<MeditationModel?> getMeditation() async {
    try {
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> meditationsList = [];

      meditationsList = await db.rawQuery(
        "SELECT * FROM meditation WHERE id = ? ORDER BY id DESC LIMIT 1",
        [id],
      );

      if (meditationsList.isNotEmpty) {
        MeditationModel meditation =
            MeditationModel.fromJson(meditationsList[0]);
        return meditation;
      }

      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> changeMeditationStatusToCompleted() async {
    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE meditation SET isCompleted = ? WHERE id = ?',
        [1, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> updateMeditationDuration(
      {required int durationInSeconds}) async {
    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE meditation SET duration = ? WHERE id = ?',
        [durationInSeconds, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
