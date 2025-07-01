import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static bool _isInitialized = false;

  static Future<void> initializeDatabase() async {
    if (!_isInitialized) {
      try {
        if (kIsWeb) {
          databaseFactory = databaseFactoryFfiWeb;
        } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
        }

        final database = AppDatabase();
        await database
            .database;
        _isInitialized = true;
      } catch (e) {
        rethrow;
      }
    }
  }

  static Future<void> resetDatabase() async {
    try {
      final database = AppDatabase();
      await database.deleteDatabase();
      _isInitialized = false;
      await initializeDatabase();
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isDatabaseInitialized() async {
    final database = AppDatabase();
    return await database.databaseExists();
  }
}
