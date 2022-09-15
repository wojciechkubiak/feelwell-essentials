import 'dart:async';

import '../models/models.dart';
import '../services/services.dart';

abstract class DataWaterService {
  Future<WaterModel?> initWaterRecord();
  Future<WaterModel?> getWater({required int id});
  Future<bool> updateWater({required WaterModel waterModel});
  Future<bool> updateDrunkWater({required int drunk});
  Future<bool> updateWaterToDrink({required int toDrink});
}

class WaterService extends DataWaterService {
  @override
  Future<WaterModel?> initWaterRecord() async {
    int id = Ids.getRecordId();

    StorageService storageService = StorageService();
    SettingsService settingsService = SettingsService();

    final db = await storageService.getDatabase();

    SettingsModel? settings = await settingsService.getSettings();
    WaterModel? water = await getWater(id: id);

    if (settings is SettingsModel && water is! WaterModel) {
      WaterModel defaultWater = WaterModel(
        id: id,
        drunk: 0,
        toDrink: settings.waterToDrink,
      );

      WaterModel insertedWater =
          await db.insert('water', defaultWater.toJson()).then(
        (value) {
          print('INSERTED ${defaultWater.toJson()}');
          return defaultWater;
        },
      );

      return insertedWater;
    }

    return water;
  }

  @override
  Future<WaterModel?> getWater({required int id}) async {
    try {
      StorageService storageService = StorageService();
      final db = await storageService.getDatabase();

      List<Map<String, dynamic>> waterList = [];

      waterList = await db.rawQuery(
          "SELECT * FROM water WHERE id = ? ORDER BY id DESC LIMIT 1", [id]);

      if (waterList.isNotEmpty) {
        WaterModel water = WaterModel.fromJson(waterList[0]);
        return water;
      }

      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<bool> updateWater({required WaterModel waterModel}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();
      int id = Ids.getRecordId();

      int count = await db.rawUpdate(
        'UPDATE water SET drunk = ?, toDrink = ? WHERE id = ?',
        [waterModel.drunk, waterModel.toDrink, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> updateDrunkWater({required int drunk}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();
      int id = Ids.getRecordId();

      int count = await db.rawUpdate(
        'UPDATE water SET drunk = ? WHERE id = ?',
        [drunk, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> updateWaterToDrink({required int toDrink}) async {
    StorageService storageService = StorageService();

    try {
      final db = await storageService.getDatabase();
      int id = Ids.getRecordId();

      int count = await db.rawUpdate(
        'UPDATE water SET toDrink = ? WHERE id = ?',
        [toDrink, id],
      );

      return count > 0;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
