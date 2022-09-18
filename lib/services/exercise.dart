import 'dart:async';

import '../models/models.dart';
import '../services/services.dart';

abstract class DataExerciseService {
  Future<ExerciseModel?> initExercise();
  Future<ExerciseModel?> getExercise();
  Future<bool> changeExerciseStatusToCompleted();
  Future<bool> updateExerciseDuration({required int durationInSeconds});
}

class ExerciseService extends DataExerciseService {
  final StorageService storageService = StorageService();
  final SettingsService settingsService = SettingsService();
  final int id = Ids.getRecordId();

  @override
  Future<ExerciseModel?> initExercise() async {
    final db = await storageService.getDatabase();

    SettingsModel? settings = await settingsService.getSettings();
    ExerciseModel? exercise = await getExercise();

    if (settings is SettingsModel && exercise is! ExerciseModel) {
      ExerciseModel defaultExercise = ExerciseModel(
        id: id,
        duration: settings.exerciseLength,
        isCompleted: 0,
      );

      ExerciseModel insertedExercise =
          await db.insert('exercise', defaultExercise.toJson()).then(
        (value) {
          print('EXERCISE INIT WITH: ${defaultExercise.toJson()}');
          return defaultExercise;
        },
      );

      return insertedExercise;
    }

    return exercise;
  }

  @override
  Future<ExerciseModel?> getExercise() async {
    try {
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> exercisesList = [];

      exercisesList = await db.rawQuery(
        "SELECT * FROM exercise WHERE id = ? ORDER BY id DESC LIMIT 1",
        [id],
      );

      if (exercisesList.isNotEmpty) {
        ExerciseModel exercise = ExerciseModel.fromJson(exercisesList[0]);
        return exercise;
      }

      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> changeExerciseStatusToCompleted() async {
    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE exercise SET isCompleted = ? WHERE id = ?',
        [1, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> updateExerciseDuration({required int durationInSeconds}) async {
    try {
      final db = await storageService.getDatabase();

      int count = await db.rawUpdate(
        'UPDATE exercise SET duration = ? WHERE id = ?',
        [durationInSeconds, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
