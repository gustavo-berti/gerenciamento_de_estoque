import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/domain/entities/address.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';

class SupplierDaoNew {
  static const String tableName = 'suppliers';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<Supplier>> getAllSuppliers() async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT s.*, a.street, a.number, a.address_line2, a.city_id,
             c.name as city_name
      FROM suppliers s
      INNER JOIN addresses a ON s.address_id = a.id
      INNER JOIN cities c ON a.city_id = c.id
    ''');
    
    return result.map((map) {
      // Criar cidade simplificada apenas com nome e id
      final city = City(
        id: map['city_id'] as int?,
        name: map['city_name'] as String,
        stateId: 0, // Simplificado por enquanto
      );
      
      final address = Address(
        street: map['street'] as String,
        number: map['number'] as String,
        addressLine2: map['address_line2'] as String,
        city: city,
      );
      
      return Supplier(
        id: map['id'] as int,
        name: map['name'] as String,
        phoneNumber: map['phone_number'] as String,
        enterprise: map['enterprise'] as String,
        email: map['email'] as String,
        address: address,
        products: [], // Será carregado separadamente se necessário
      );
    }).toList();
  }

  Future<Supplier?> getSupplierById(int id) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT s.*, a.street, a.number, a.address_line2, a.city_id,
             c.name as city_name
      FROM suppliers s
      INNER JOIN addresses a ON s.address_id = a.id
      INNER JOIN cities c ON a.city_id = c.id
      WHERE s.id = ?
    ''', [id]);
    
    if (result.isNotEmpty) {
      final map = result.first;
      final city = City(
        id: map['city_id'] as int?,
        name: map['city_name'] as String,
        stateId: 0,
      );
      
      final address = Address(
        street: map['street'] as String,
        number: map['number'] as String,
        addressLine2: map['address_line2'] as String,
        city: city,
      );
      
      return Supplier(
        id: map['id'] as int,
        name: map['name'] as String,
        phoneNumber: map['phone_number'] as String,
        enterprise: map['enterprise'] as String,
        email: map['email'] as String,
        address: address,
        products: [],
      );
    }
    return null;
  }

  Future<int> insertSupplier(Supplier supplier) async {
    final db = await _db;
    
    // Por enquanto, criar endereço simplificado
    final addressId = await _insertAddress(db, supplier.address);
    
    // Inserir fornecedor
    return await db.insert(tableName, {
      'name': supplier.name,
      'phone_number': supplier.phoneNumber,
      'enterprise': supplier.enterprise,
      'email': supplier.email,
      'address_id': addressId,
    });
  }

  Future<int> _insertAddress(Database db, Address address) async {
    // Por enquanto, usar apenas city_id diretamente
    return await db.insert('addresses', {
      'street': address.street,
      'number': address.number,
      'address_line2': address.addressLine2,
      'city_id': address.city.id ?? 1, // Default para a primeira cidade
    });
  }

  Future<void> updateSupplier(Supplier supplier) async {
    final db = await _db;
    await db.update(
      tableName,
      {
        'name': supplier.name,
        'phone_number': supplier.phoneNumber,
        'enterprise': supplier.enterprise,
        'email': supplier.email,
      },
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  Future<void> deleteSupplier(int id) async {
    final db = await _db;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
