import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart';

class StateDao {
  static const String tableName = 'states';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<State>> getAllStates() async {
    final db = await _db;
    final result = await db.query(tableName, orderBy: 'name');
    
    return result.map((map) => State.fromMap(map)).toList();
  }

  Future<List<State>> getStatesByCountry(int countryId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'country_id = ?',
      whereArgs: [countryId],
      orderBy: 'name',
    );
    
    return result.map((map) => State.fromMap(map)).toList();
  }

  Future<State?> getStateById(int id) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return State.fromMap(result.first);
    }
    return null;
  }

  Future<State?> getStateByNameAndCountry(String name, int countryId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'name = ? AND country_id = ?',
      whereArgs: [name, countryId],
    );
    
    if (result.isNotEmpty) {
      return State.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertState(State state) async {
    final db = await _db;
    return await db.insert(tableName, state.toMap());
  }

  Future<void> updateState(State state) async {
    final db = await _db;
    await db.update(
      tableName,
      state.toMap(),
      where: 'id = ?',
      whereArgs: [state.id],
    );
  }

  Future<void> deleteState(int id) async {
    final db = await _db;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> hasStates(int countryId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'country_id = ?',
      whereArgs: [countryId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> hasCities(int stateId) async {
    final db = await _db;
    final result = await db.query(
      'cities',
      where: 'state_id = ?',
      whereArgs: [stateId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
