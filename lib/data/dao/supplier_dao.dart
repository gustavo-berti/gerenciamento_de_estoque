import 'package:sqflite/sqflite.dart';
import 'package:gerenciamento_de_estoque/core/database/app_database.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/domain/entities/address.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';

class SupplierDao {
  static const String tableName = 'suppliers';
  
  Future<Database> get _db async => AppDatabase().database;

  Future<List<Supplier>> getAllSuppliers() async {
    final db = await _db;
    try {
      final result = await db.rawQuery('''
        SELECT s.*, a.street, a.number, a.address_line2,
               c.id as city_id, c.name as city_name, 
               st.id as state_id, st.name as state_name, st.acronym as state_acronym,
               co.id as country_id, co.name as country_name
        FROM suppliers s
        INNER JOIN addresses a ON s.address_id = a.id
        INNER JOIN cities c ON a.city_id = c.id
        INNER JOIN states st ON c.state_id = st.id
        INNER JOIN countries co ON st.country_id = co.id
      ''');
      
      return result.map((map) {
        final city = City(
          id: map['city_id'] as int?,
          name: map['city_name'] as String? ?? '',
          stateId: map['state_id'] as int? ?? 0,
        );
        final address = Address(
          street: map['street'] as String? ?? '',
          number: map['number'] as String? ?? '',
          addressLine2: map['address_line2'] as String? ?? '',
          city: city,
        );
        
        return Supplier(
          id: map['id'] as int?,
          name: map['name'] as String? ?? '',
          phoneNumber: map['phone_number'] as String? ?? '',
          enterprise: map['enterprise'] as String? ?? '',
          email: map['email'] as String? ?? '',
          address: address,
          products: [], // Will be loaded separately if needed
        );
      }).toList();
    } catch (e) {
      print('Error in getAllSuppliers: $e');
      return [];
    }
  }

  Future<Supplier?> getSupplierById(int id) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT s.*, a.street, a.number, a.address_line2,
             c.name as city_name, st.name as state_name, st.acronym as state_acronym,
             co.name as country_name
      FROM suppliers s
      INNER JOIN addresses a ON s.address_id = a.id
      INNER JOIN cities c ON a.city_id = c.id
      INNER JOIN states st ON c.state_id = st.id
      INNER JOIN countries co ON st.country_id = co.id
      WHERE s.id = ?
    ''', [id]);
    
    if (result.isNotEmpty) {
      final map = result.first;
      final city = City(
        name: map['city_name'] as String,
        stateId: map['state_id'] as int,
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
        products: [], // Will be loaded separately if needed
      );
    }
    return null;
  }

  Future<Supplier?> getSupplierByName(String name) async {
    final db = await _db;
    final result = await db.rawQuery('''
      SELECT s.*, a.street, a.number, a.address_line2,
             c.name as city_name, st.name as state_name, st.acronym as state_acronym,
             co.name as country_name
      FROM suppliers s
      INNER JOIN addresses a ON s.address_id = a.id
      INNER JOIN cities c ON a.city_id = c.id
      INNER JOIN states st ON c.state_id = st.id
      INNER JOIN countries co ON st.country_id = co.id
      WHERE s.name = ?
    ''', [name]);
    
    if (result.isNotEmpty) {
      final map = result.first;
      final city = City(
        name: map['city_name'] as String,
        stateId: map['state_id'] as int,
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
        products: [], // Will be loaded separately if needed
      );
    }
    return null;
  }

  Future<int> insertSupplier(Supplier supplier) async {
    final db = await _db;
    
    // First, insert the address
    final addressId = await _insertAddress(db, supplier.address);
    
    // Then insert the supplier
    return await db.insert(tableName, {
      'name': supplier.name,
      'phone_number': supplier.phoneNumber,
      'enterprise': supplier.enterprise,
      'email': supplier.email,
      'address_id': addressId,
    });
  }

  Future<int> _insertAddress(Database db, Address address) async {
    // The city should already have a valid stateId at this point
    // since we're using the service to find/create the entities
    if (address.city.id == null) {
      throw Exception('City must have an ID before creating address');
    }

    // Insert address with the city ID
    return await db.insert('addresses', {
      'street': address.street,
      'number': address.number,
      'address_line2': address.addressLine2,
      'city_id': address.city.id,
    });
  }

  Future<int> updateSupplier(int id, Supplier supplier) async {
    final db = await _db;
    return await db.update(
      tableName,
      {
        'name': supplier.name,
        'phone_number': supplier.phoneNumber,
        'enterprise': supplier.enterprise,
        'email': supplier.email,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSupplier(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getSupplierNames() async {
    final suppliers = await getAllSuppliers();
    return suppliers.map((supplier) => supplier.name).toList();
  }
}
