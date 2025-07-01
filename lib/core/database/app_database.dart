import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'database_scripts.dart';

class AppDatabase {
  static Database? _database;
  static const String dbName = 'gerenciamento_estoque.db';
  static const int dbVersion = 1;

  // Singleton instance
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    print('Database path: $path');

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criar todas as tabelas usando os scripts do arquivo separado
    for (String script in DatabaseScripts.createAllTables) {
      await db.execute(script);
    }

    // Inserir dados iniciais
    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Drop existing tables and recreate (for simplicity in development)
      // In production, you would write migration scripts
      for (String dropScript in DatabaseScripts.dropAllTables) {
        await db.execute(dropScript);
      }

      await _onCreate(db, newVersion);
    }
  }

  Future<void> _insertInitialData(Database db) async {
    // Inserir países
    for (Map<String, dynamic> country in DatabaseScripts.initialCountries) {
      await db.insert('countries', country);
    }

    // Inserir estados
    for (Map<String, dynamic> state in DatabaseScripts.initialStates) {
      await db.insert('states', state);
    }

    // Inserir cidades
    for (Map<String, dynamic> city in DatabaseScripts.initialCities) {
      await db.insert('cities', city);
    }

    // Inserir categorias
    for (Map<String, dynamic> category in DatabaseScripts.initialCategories) {
      await db.insert('categories', category);
    }

    // Inserir endereços
    for (Map<String, dynamic> address in DatabaseScripts.initialAddresses) {
      await db.insert('addresses', address);
    }

    // Inserir fornecedores
    for (Map<String, dynamic> supplier in DatabaseScripts.initialSuppliers) {
      await db.insert('suppliers', supplier);
    }

    // Inserir usuários
    for (Map<String, dynamic> user in DatabaseScripts.initialUsers) {
      await db.insert('users', user);
    }
  }

  // Método para fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Método para deletar o banco de dados (útil para testes)
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // Método para verificar se o banco existe
  Future<bool> databaseExists() async {
    String path = join(await getDatabasesPath(), dbName);
    return await databaseFactory.databaseExists(path);
  }
}
