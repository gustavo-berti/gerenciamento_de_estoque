import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';

class CityDao {
  static const String tableName = 'cities';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<City>> getAllCities() async {
    final db = await _db;
    final result = await db.query(tableName, orderBy: 'name');
    
    return result.map((map) => City.fromMap(map)).toList();
  }

  Future<List<City>> getCitiesByState(int stateId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'state_id = ?',
      whereArgs: [stateId],
      orderBy: 'name',
    );
    
    return result.map((map) => City.fromMap(map)).toList();
  }

  Future<City?> getCityById(int id) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return City.fromMap(result.first);
    }
    return null;
  }

  Future<City?> getCityByNameAndState(String name, int stateId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'name = ? AND state_id = ?',
      whereArgs: [name, stateId],
    );
    
    if (result.isNotEmpty) {
      return City.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertCity(City city) async {
    final db = await _db;
    return await db.insert(tableName, city.toMap());
  }

  Future<void> updateCity(City city) async {
    final db = await _db;
    await db.update(
      tableName,
      city.toMap(),
      where: 'id = ?',
      whereArgs: [city.id],
    );
  }

  Future<void> deleteCity(int id) async {
    final db = await _db;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> hasCities(int stateId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'state_id = ?',
      whereArgs: [stateId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
