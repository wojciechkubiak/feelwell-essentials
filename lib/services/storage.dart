import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DataStorageService {
  Future<Database> getDatabase();
}

class StorageService extends DataStorageService {
  @override
  Future<Database> getDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'star_metter.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE settings (id INTEGER PRIMARY KEY, waterCapacity INTEGER, waterToDrink INTEGER, fastingLength INTEGER, fastingStartHour INTEGER, fastingStartMinutes	INTEGER, exerciseLength INTEGER, meditationLength INTEGER)');
        await db.execute(
            'CREATE TABLE water (id INTEGER, drunk INTEGER, toDrink INTEGER)');
        await db.execute(
            'CREATE TABLE fasting (id INTEGER, startHour INTEGER, startMinutes INTEGER, fastinglength INTEGER)');
        await db.execute(
            'CREATE TABLE exercise (id INTEGER, duration INTEGER, completed INTEGER)');
        await db
            .execute('CREATE TABLE meditation (id INTEGER, duration INTEGER)');
      },
      version: 1,
    );

    return database;
  }
}
