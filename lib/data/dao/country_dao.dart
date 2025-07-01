import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';

class CountryDao {
  static const String tableName = 'countries';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<Country>> getAllCountries() async {
    final db = await _db;
    final result = await db.query(tableName, orderBy: 'name ASC');
    
    return result.map((map) => Country.fromMap(map)).toList();
  }

  Future<Country?> getCountryById(int id) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return Country.fromMap(result.first);
    }
    return null;
  }

  Future<Country?> getCountryByName(String name) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
    );
    
    if (result.isNotEmpty) {
      return Country.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertCountry(Country country) async {
    final db = await _db;
    return await db.insert(tableName, {
      'name': country.name,
    });
  }

  Future<int> updateCountry(int id, Country country) async {
    final db = await _db;
    return await db.update(
      tableName,
      {
        'name': country.name,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCountry(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> hasStates(int countryId) async {
    final db = await _db;
    final result = await db.query(
      'states',
      where: 'country_id = ?',
      whereArgs: [countryId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
