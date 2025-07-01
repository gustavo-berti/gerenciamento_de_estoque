import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';

class CategoryDao {
  static const String tableName = 'categories';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<Category>> getAllCategories() async {
    final db = await _db;
    final result = await db.query(tableName);
    
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return Category.fromMap(result.first);
    }
    return null;
  }

  Future<Category?> getCategoryByName(String name) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
    );
    
    if (result.isNotEmpty) {
      return Category.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertCategory(Category category) async {
    final db = await _db;
    return await db.insert(tableName, {
      'name': category.name,
      'description': category.description,
      'acronym': category.acronym,
    });
  }

  Future<int> updateCategory(int id, Category category) async {
    final db = await _db;
    return await db.update(
      tableName,
      {
        'name': category.name,
        'description': category.description,
        'acronym': category.acronym,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getCategoryNames() async {
    final categories = await getAllCategories();
    return categories.map((category) => category.name).toList();
  }
}
