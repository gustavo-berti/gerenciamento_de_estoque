import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';

class ProductDao {
  static const String tableName = 'products';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<Product>> getAllProducts() async {
    final db = await _db;
    final result = await db.query(tableName, orderBy: 'name ASC');
    
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<Product?> getProductByName(String name) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
    );
    
    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'name ASC',
    );
    
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getProductsBySupplier(int supplierId) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
      orderBy: 'name ASC',
    );
    
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getLowStockProducts(int threshold) async {
    final db = await _db;
    final result = await db.query(
      tableName,
      where: 'amount <= ?',
      whereArgs: [threshold],
      orderBy: 'amount ASC',
    );
    
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> insertProduct(Product product) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    
    return await db.insert(tableName, {
      'name': product.name,
      'amount': product.amount,
      'purchase_price': product.purchasePrice,
      'sell_price': product.sellPrice,
      'category_id': product.categoryId,
      'supplier_id': product.supplierId,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<int> updateProduct(int id, Product product) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    
    return await db.update(
      tableName,
      {
        'name': product.name,
        'amount': product.amount,
        'purchase_price': product.purchasePrice,
        'sell_price': product.sellPrice,
        'category_id': product.categoryId,
        'supplier_id': product.supplierId,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateProductStock(int id, int newAmount) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    
    return await db.update(
      tableName,
      {
        'amount': newAmount,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getProductsWithDetails() async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT p.*, 
             c.name as category_name, 
             c.acronym as category_acronym,
             s.name as supplier_name,
             s.enterprise as supplier_enterprise
      FROM products p
      INNER JOIN categories c ON p.category_id = c.id
      INNER JOIN suppliers s ON p.supplier_id = s.id
      ORDER BY p.name ASC
    ''');
    
    return result;
  }

  Future<Map<String, dynamic>?> getProductWithDetailsById(int id) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT p.*, 
             c.name as category_name, 
             c.acronym as category_acronym,
             s.name as supplier_name,
             s.enterprise as supplier_enterprise
      FROM products p
      INNER JOIN categories c ON p.category_id = c.id
      INNER JOIN suppliers s ON p.supplier_id = s.id
      WHERE p.id = ?
    ''', [id]);
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
