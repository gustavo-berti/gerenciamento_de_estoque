import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';

class UserDao {
  static const String tableName = 'users';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _db;
    return await db.query(tableName);
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await _db;
    return await db.insert(tableName, {
      'name': user['name'],
      'email': user['email'],
      'password': user['password'], // In production, hash this password
      'role': user['role'] ?? 'user',
    });
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await _db;
    return await db.update(
      tableName,
      {
        'name': user['name'],
        'email': user['email'],
        'role': user['role'],
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateUserPassword(int id, String newPassword) async {
    final db = await _db;
    return await db.update(
      tableName,
      {
        'password': newPassword, // In production, hash this password
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> validateUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null) {
      // In production, compare hashed passwords
      return user['password'] == password;
    }
    return false;
  }

  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }
}
