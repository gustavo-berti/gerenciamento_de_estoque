import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stock_movement.dart';
import 'package:gerenciamento_de_estoque/domain/entities/address.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';
import 'package:gerenciamento_de_estoque/core/enums/movement_type.dart';
import 'package:gerenciamento_de_estoque/core/services/country_service.dart';
import 'package:gerenciamento_de_estoque/core/services/state_service.dart';
import 'package:gerenciamento_de_estoque/core/services/city_service.dart';
import 'package:gerenciamento_de_estoque/data/dao/category_dao.dart';
import 'package:gerenciamento_de_estoque/data/dao/supplier_dao.dart';
import 'package:gerenciamento_de_estoque/data/dao/product_dao.dart';
import 'package:gerenciamento_de_estoque/data/dao/stock_movement_dao.dart';
import 'package:gerenciamento_de_estoque/data/dao/user_dao.dart';

class StockService {
  final CategoryDao _categoryDao = CategoryDao();
  final SupplierDao _supplierDao = SupplierDao();
  final ProductDao _productDao = ProductDao();
  final StockMovementDao _stockMovementDao = StockMovementDao();
  final UserDao _userDao = UserDao();

  // Category operations
  Future<List<Category>> getAllCategories() async {
    return await _categoryDao.getAllCategories();
  }

  Future<Category?> addCategory(String name, String description, String acronym) async {
    final category = Category(
      name: name,
      description: description,
      acronym: acronym,
    );
    
    try {
      await _categoryDao.insertCategory(category);
      return category;
    } catch (e) {
      print('Error adding category: $e');
      return null;
    }
  }

  // Supplier operations
  Future<List<Supplier>> getAllSuppliers() async {
    try {
      return await _supplierDao.getAllSuppliers();
    } catch (e) {
      print('Error getting all suppliers: $e');
      return [];
    }
  }
  Future<Supplier?> addSupplier({
    required String name,
    required String phoneNumber,
    required String enterprise,
    required String email,
    required String street,
    required String number,
    required String addressLine2,
    required String cityName,
    required String stateName,
    required String stateAcronym,
    required String countryName,
  }) async {
    try {
      // Find or create country
      final countryService = CountryService();
      var country = (await countryService.getAllCountries())
          .where((c) => c.name == countryName).firstOrNull;
      if (country == null) {
        country = await countryService.addCountry(countryName);
        if (country == null) throw Exception('Failed to create country');
      }

      // Find or create state
      final stateService = StateService();
      var state = (await stateService.getStatesByCountry(country.id!))
          .where((s) => s.name == stateName).firstOrNull;
      if (state == null) {
        state = await stateService.addState(name: stateName, acronym: stateAcronym, countryId: country.id!);
        if (state == null) throw Exception('Failed to create state');
      }

      // Find or create city
      final cityService = CityService();
      var city = (await cityService.getCitiesByState(state.id!))
          .where((c) => c.name == cityName).firstOrNull;
      if (city == null) {
        city = await cityService.addCity(name: cityName, stateId: state.id!);
        if (city == null) throw Exception('Failed to create city');
      }

      final address = Address(
        street: street,
        number: number,
        addressLine2: addressLine2,
        city: city,
      );
      
      final supplier = Supplier(
        name: name,
        phoneNumber: phoneNumber,
        enterprise: enterprise,
        email: email,
        address: address,
        products: [],
      );

      await _supplierDao.insertSupplier(supplier);
      return supplier;
    } catch (e) {
      print('Error adding supplier: $e');
      return null;
    }
  }

  // Additional supplier operations
  Future<bool> updateSupplier(int supplierId, {
    required String name,
    required String phoneNumber,
    required String enterprise,
    required String email,
  }) async {
    try {
      await _supplierDao.updateSupplier(supplierId, Supplier(
        name: name,
        phoneNumber: phoneNumber,
        enterprise: enterprise,
        email: email,
        address: Address(
          street: '',
          addressLine2: '',
          city: City(
            name: '',
            stateId: 1,
          ),
        ),
        products: [],
      ));
      return true;
    } catch (e) {
      print('Error updating supplier: $e');
      return false;
    }
  }

  Future<bool> deleteSupplier(int supplierId) async {
    try {
      await _supplierDao.deleteSupplier(supplierId);
      return true;
    } catch (e) {
      print('Error deleting supplier: $e');
      return false;
    }
  }

  // Product operations
  Future<List<Product>> getAllProducts() async {
    return await _productDao.getAllProducts();
  }

  Future<Product?> addProduct({
    required String name,
    required String categoryName,
    required String supplierName,
    int initialAmount = 0,
  }) async {
    try {
      final category = await _categoryDao.getCategoryByName(categoryName);
      final supplier = await _supplierDao.getSupplierByName(supplierName);
      
      if (category == null) {
        throw Exception('Category not found: $categoryName');
      }
      
      if (supplier == null) {
        throw Exception('Supplier not found: $supplierName');
      }
      
      final product = Product(
        name: name,
        amount: initialAmount,
        purchasePrice: 0.0, // Valor padrão, pode ser atualizado depois
        sellPrice: 0.0, // Valor padrão, pode ser atualizado depois
        categoryId: category.id!,
        supplierId: supplier.id!,
      );
      
      await _productDao.insertProduct(product);
      return product;
    } catch (e) {
      print('Error adding product: $e');
      return null;
    }
  }

  Future<List<Product>> getLowStockProducts({int threshold = 10}) async {
    return await _productDao.getLowStockProducts(threshold);
  }

  // Stock movement operations
  Future<bool> addStockEntry({
    required String productName,
    required int amount,
    String? reason,
  }) async {
    try {
      final products = await _productDao.getAllProducts();
      final product = products.firstWhere(
        (p) => p.name == productName,
        orElse: () => throw Exception('Product not found: $productName'),
      );
      
      final movement = StockMovement(
        product: product,
        amount: amount,
        date: DateTime.now(),
        type: MovementType.entry,
      );
      
      // Get product ID from database
      final allProducts = await _productDao.getAllProducts();
      final productIndex = allProducts.indexWhere((p) => p.name == productName);
      if (productIndex == -1) {
        throw Exception('Product not found in database');
      }
      
      if (reason != null) {
        await _stockMovementDao.insertMovementWithReason(movement, productIndex + 1, reason);
      } else {
        await _stockMovementDao.insertMovement(movement, productIndex + 1);
      }
      
      return true;
    } catch (e) {
      print('Error adding stock entry: $e');
      return false;
    }
  }

  Future<bool> addStockExit({
    required String productName,
    required int amount,
    String? reason,
  }) async {
    try {
      final products = await _productDao.getAllProducts();
      final product = products.firstWhere(
        (p) => p.name == productName,
        orElse: () => throw Exception('Product not found: $productName'),
      );
      
      if (product.amount < amount) {
        throw Exception('Insufficient stock. Available: ${product.amount}, Requested: $amount');
      }
      
      final movement = StockMovement(
        product: product,
        amount: amount,
        date: DateTime.now(),
        type: MovementType.exit,
      );
      
      // Get product ID from database
      final allProducts = await _productDao.getAllProducts();
      final productIndex = allProducts.indexWhere((p) => p.name == productName);
      if (productIndex == -1) {
        throw Exception('Product not found in database');
      }
      
      if (reason != null) {
        await _stockMovementDao.insertMovementWithReason(movement, productIndex + 1, reason);
      } else {
        await _stockMovementDao.insertMovement(movement, productIndex + 1);
      }
      
      return true;
    } catch (e) {
      print('Error adding stock exit: $e');
      return false;
    }
  }

  Future<StockMovement?> addStockMovement({
    required int productId,
    required int amount,
    required MovementType type,
  }) async {
    try {
      // Get the product first
      final product = await _productDao.getProductById(productId);
      if (product == null) {
        print('Product not found with id: $productId');
        return null;
      }
      
      final movement = StockMovement(
        product: product,
        amount: amount,
        type: type,
        date: DateTime.now(),
      );
      
      await _stockMovementDao.insertMovement(movement, productId);
      return movement;
    } catch (e) {
      print('Error adding stock movement: $e');
      return null;
    }
  }

  Future<List<StockMovement>> getAllMovements() async {
    try {
      return await _stockMovementDao.getAllMovements();
    } catch (e) {
      print('Error getting all movements: $e');
      return [];
    }
  }

  Future<List<StockMovement>> getMovementsByProduct(int productId) async {
    try {
      return await _stockMovementDao.getMovementsByProduct(productId);
    } catch (e) {
      print('Error getting movements by product: $e');
      return [];
    }
  }

  // User operations
  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    try {
      final userExists = await _userDao.emailExists(email);
      if (userExists) {
        throw Exception('User with email $email already exists');
      }
      
      await _userDao.insertUser({
        'name': name,
        'email': email,
        'password': password, // In production, hash this password
        'role': role,
      });
      
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<bool> authenticateUser(String email, String password) async {
    return await _userDao.validateUser(email, password);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return await _userDao.getUserByEmail(email);
  }

  // Database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final categories = await _categoryDao.getAllCategories();
    final suppliers = await _supplierDao.getAllSuppliers();
    final products = await _productDao.getAllProducts();
    final users = await _userDao.getAllUsers();
    final movements = await _stockMovementDao.getAllMovements();
    
    return {
      'categories': categories.length,
      'suppliers': suppliers.length,
      'products': products.length,
      'users': users.length,
      'movements': movements.length,
    };
  }
}
