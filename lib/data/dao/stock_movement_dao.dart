import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stock_movement.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';

class StockMovementDao {
  static const String tableName = 'stock_movements';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<StockMovement>> getAllMovements() async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT sm.*, p.name as product_name, p.amount as product_amount,
             c.name as category_name, c.description as category_description, c.acronym as category_acronym,
             s.name as supplier_name, s.phone_number, s.enterprise, s.email
      FROM stock_movements sm
      INNER JOIN products p ON sm.product_id = p.id
      INNER JOIN categories c ON p.category_id = c.id
      INNER JOIN suppliers s ON p.supplier_id = s.id
      ORDER BY sm.date DESC
    ''');
    
    return result.map((map) => _mapToStockMovement(map)).toList();
  }

  Future<List<StockMovement>> getMovementsByProduct(int productId) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT sm.*, p.name as product_name, p.amount as product_amount,
             c.name as category_name, c.description as category_description, c.acronym as category_acronym,
             s.name as supplier_name, s.phone_number, s.enterprise, s.email
      FROM stock_movements sm
      INNER JOIN products p ON sm.product_id = p.id
      INNER JOIN categories c ON p.category_id = c.id
      INNER JOIN suppliers s ON p.supplier_id = s.id
      WHERE sm.product_id = ?
      ORDER BY sm.date DESC
    ''', [productId]);
    
    return result.map((map) => _mapToStockMovement(map)).toList();
  }

  Future<List<StockMovement>> getMovementsByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT sm.*, p.name as product_name, p.amount as product_amount,
             c.name as category_name, c.description as category_description, c.acronym as category_acronym,
             s.name as supplier_name, s.phone_number, s.enterprise, s.email
      FROM stock_movements sm
      INNER JOIN products p ON sm.product_id = p.id
      INNER JOIN categories c ON p.category_id = c.id
      INNER JOIN suppliers s ON p.supplier_id = s.id
      WHERE sm.date BETWEEN ? AND ?
      ORDER BY sm.date DESC
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);
    
    return result.map((map) => _mapToStockMovement(map)).toList();
  }

  Future<List<StockMovement>> getMovementsByType(MovementType type) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT sm.*, p.name as product_name, p.amount as product_amount,
             c.name as category_name, c.description as category_description, c.acronym as category_acronym,
             s.name as supplier_name, s.phone_number, s.enterprise, s.email
      FROM stock_movements sm
      INNER JOIN products p ON sm.product_id = p.id
      INNER JOIN categories c ON p.category_id = c.id
      INNER JOIN suppliers s ON p.supplier_id = s.id
      WHERE sm.movement_type = ?
      ORDER BY sm.date DESC
    ''', [type.name]);
    
    return result.map((map) => _mapToStockMovement(map)).toList();
  }

  Future<int> insertMovement(StockMovement movement, int productId) async {
    final db = await _db;
    
    return await db.transaction((txn) async {
      // Get current product data using the transaction
      final productResult = await txn.query(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
      );
      
      if (productResult.isEmpty) {
        throw Exception('Product not found with id: $productId');
      }
      
      final currentAmount = productResult.first['amount'] as int;
      
      // Calculate new amount
      int newAmount = currentAmount;
      switch (movement.type) {
        case MovementType.entry:
          newAmount += movement.amount;
          break;
        case MovementType.exit:
          newAmount -= movement.amount;
          break;
      }
      
      // Prevent negative stock for exit movements
      if (newAmount < 0) {
        throw Exception('Insufficient stock. Current: $currentAmount, Requested: ${movement.amount}');
      }
      
      // Insert the movement
      final movementId = await txn.insert(tableName, {
        'product_id': productId,
        'amount': movement.amount,
        'movement_type': movement.type.name,
        'date': movement.date.toIso8601String(),
        'reason': '', // You might want to add a reason field to StockMovement
      });
      
      // Update product stock
      await txn.update(
        'products',
        {
          'amount': newAmount,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [productId],
      );
      
      return movementId;
    });
  }

  Future<int> insertMovementWithReason(StockMovement movement, int productId, String reason) async {
    final db = await _db;
    
    return await db.transaction((txn) async {
      // Get current product data using the transaction
      final productResult = await txn.query(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
      );
      
      if (productResult.isEmpty) {
        throw Exception('Product not found with id: $productId');
      }
      
      final currentAmount = productResult.first['amount'] as int;
      
      // Calculate new amount
      int newAmount = currentAmount;
      switch (movement.type) {
        case MovementType.entry:
          newAmount += movement.amount;
          break;
        case MovementType.exit:
          newAmount -= movement.amount;
          break;
      }
      
      // Prevent negative stock
      if (newAmount < 0) {
        throw Exception('Insufficient stock. Current: $currentAmount, Requested: ${movement.amount}');
      }
      
      // Insert the movement
      final movementId = await txn.insert(tableName, {
        'product_id': productId,
        'amount': movement.amount,
        'movement_type': movement.type.name,
        'date': movement.date.toIso8601String(),
        'reason': reason,
      });
      
      // Update product stock
      await txn.update(
        'products',
        {
          'amount': newAmount,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [productId],
      );
      
      return movementId;
    });
  }

  Future<int> deleteMovement(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, int>> getMovementSummary() async {
    final db = await _db;
    final entriesResult = await db.rawQuery('''
      SELECT SUM(amount) as total_entries
      FROM stock_movements
      WHERE movement_type = 'entry'
    ''');
    
    final exitsResult = await db.rawQuery('''
      SELECT SUM(amount) as total_exits
      FROM stock_movements
      WHERE movement_type = 'exit'
    ''');
    
    final totalEntries = entriesResult.first['total_entries'] as int? ?? 0;
    final totalExits = exitsResult.first['total_exits'] as int? ?? 0;
    
    return {
      'total_entries': totalEntries,
      'total_exits': totalExits,
      'net_movement': totalEntries - totalExits,
    };
  }

  StockMovement _mapToStockMovement(Map<String, Object?> map) {
    // Create a simplified product for the movement
    final product = Product(
      id: map['product_id'] as int?,
      name: map['product_name'] as String,
      amount: map['product_amount'] as int,
      purchasePrice: (map['purchase_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0.0,
      categoryId: (map['category_id'] as int?) ?? 0,
      supplierId: (map['supplier_id'] as int?) ?? 0,
    );
    
    return StockMovement(
      product: product,
      amount: map['amount'] as int,
      date: DateTime.parse(map['date'] as String),
      type: MovementType.values.firstWhere(
        (type) => type.name == map['movement_type'] as String,
      ),
    );
  }
}
