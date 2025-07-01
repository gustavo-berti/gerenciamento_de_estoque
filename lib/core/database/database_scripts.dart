class DatabaseScripts {
  // Scripts de criação das tabelas
  static const String createCountriesTable = '''
    CREATE TABLE countries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE
    )
  ''';

  static const String createStatesTable = '''
    CREATE TABLE states (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      acronym TEXT NOT NULL,
      country_id INTEGER NOT NULL,
      FOREIGN KEY (country_id) REFERENCES countries (id) ON DELETE CASCADE
    )
  ''';

  static const String createCitiesTable = '''
    CREATE TABLE cities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      state_id INTEGER NOT NULL,
      FOREIGN KEY (state_id) REFERENCES states (id) ON DELETE CASCADE
    )
  ''';

  static const String createAddressesTable = '''
    CREATE TABLE addresses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      street TEXT NOT NULL,
      number TEXT DEFAULT '',
      address_line2 TEXT NOT NULL,
      city_id INTEGER NOT NULL,
      FOREIGN KEY (city_id) REFERENCES cities (id) ON DELETE CASCADE
    )
  ''';

  static const String createCategoriesTable = '''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      description TEXT NOT NULL,
      acronym TEXT NOT NULL UNIQUE
    )
  ''';

  static const String createSuppliersTable = '''
    CREATE TABLE suppliers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone_number TEXT NOT NULL,
      enterprise TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      address_id INTEGER NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (address_id) REFERENCES addresses (id) ON DELETE CASCADE
    )
  ''';

  static const String createProductsTable = '''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      amount INTEGER NOT NULL DEFAULT 0,
      purchase_price REAL NOT NULL DEFAULT 0.0,
      sell_price REAL NOT NULL DEFAULT 0.0,
      category_id INTEGER NOT NULL,
      supplier_id INTEGER NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE,
      FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE CASCADE
    )
  ''';

  static const String createProductSuppliersTable = '''
    CREATE TABLE product_suppliers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      supplier_id INTEGER NOT NULL,
      price REAL NOT NULL,
      sell_price REAL NOT NULL,
      is_active INTEGER NOT NULL DEFAULT 1,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
      FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE CASCADE,
      UNIQUE(product_id, supplier_id)
    )
  ''';

  static const String createStockMovementsTable = '''
    CREATE TABLE stock_movements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER NOT NULL,
      amount INTEGER NOT NULL,
      movement_type TEXT NOT NULL CHECK (movement_type IN ('entry', 'exit')),
      date DATETIME NOT NULL,
      reason TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
    )
  ''';

  static const String createUsersTable = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'user',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  // Scripts de drop para upgrade
  static const List<String> dropAllTables = [
    'DROP TABLE IF EXISTS stock_movements',
    'DROP TABLE IF EXISTS product_suppliers',
    'DROP TABLE IF EXISTS products',
    'DROP TABLE IF EXISTS suppliers',
    'DROP TABLE IF EXISTS categories',
    'DROP TABLE IF EXISTS addresses',
    'DROP TABLE IF EXISTS cities',
    'DROP TABLE IF EXISTS states',
    'DROP TABLE IF EXISTS countries',
    'DROP TABLE IF EXISTS users',
  ];

  // Lista ordenada de criação das tabelas (respeitando dependências)
  static const List<String> createAllTables = [
    createCountriesTable,
    createStatesTable,
    createCitiesTable,
    createAddressesTable,
    createCategoriesTable,
    createSuppliersTable,
    createProductsTable,
    createProductSuppliersTable,
    createStockMovementsTable,
    createUsersTable,
  ];

  // Scripts de inserção de dados iniciais

  static const List<Map<String, dynamic>> initialCategories = [
    {
      'name': 'Eletrônicos',
      'description': 'Produtos eletrônicos e tecnológicos',
      'acronym': 'ELET',
    },
    {
      'name': 'Roupas',
      'description': 'Vestuário e acessórios',
      'acronym': 'ROPA',
    },
    {
      'name': 'Alimentação',
      'description': 'Produtos alimentícios',
      'acronym': 'ALIM',
    },
  ];

  static const List<Map<String, dynamic>> initialAddresses = [
    {
      'street': 'Rua das Flores, 123',
      'number': '123',
      'address_line2': 'Centro',
      'city_id': 1,
    },
    {
      'street': 'Av. Paulista, 1000',
      'number': '1000',
      'address_line2': 'Bela Vista',
      'city_id': 1,
    },
  ];

  static const List<Map<String, dynamic>> initialSuppliers = [
    {
      'name': 'TechStore Ltda',
      'phone_number': '(11) 1234-5678',
      'enterprise': 'TechStore Comércio de Eletrônicos',
      'email': 'contato@techstore.com.br',
      'address_id': 1,
    },
    {
      'name': 'Fashion Company',
      'phone_number': '(11) 9876-5432',
      'enterprise': 'Fashion Company Ltda',
      'email': 'vendas@fashioncompany.com.br',
      'address_id': 2,
    },
  ];

  static const List<Map<String, dynamic>> initialUsers = [
    {
      'name': 'Administrador',
      'email': 'admin@empresa.com',
      'password': 'admin123', // Em produção, usar hash da senha
      'role': 'admin',
    },
  ];

  // Dados iniciais para localização
  static const List<Map<String, dynamic>> initialCountries = [
    {'id': 1, 'name': 'Brasil'},
    {'id': 2, 'name': 'Argentina'},
    {'id': 3, 'name': 'Chile'},
  ];

  static const List<Map<String, dynamic>> initialStates = [
    {'id': 1, 'name': 'São Paulo', 'acronym': 'SP', 'country_id': 1},
    {'id': 2, 'name': 'Rio de Janeiro', 'acronym': 'RJ', 'country_id': 1},
    {'id': 3, 'name': 'Minas Gerais', 'acronym': 'MG', 'country_id': 1},
    {'id': 4, 'name': 'Paraná', 'acronym': 'PR', 'country_id': 1},
    {'id': 5, 'name': 'Rio Grande do Sul', 'acronym': 'RS', 'country_id': 1},
  ];

  static const List<Map<String, dynamic>> initialCities = [
    {'id': 1, 'name': 'São Paulo', 'state_id': 1},
    {'id': 2, 'name': 'Campinas', 'state_id': 1},
    {'id': 3, 'name': 'Santos', 'state_id': 1},
    {'id': 4, 'name': 'Rio de Janeiro', 'state_id': 2},
    {'id': 5, 'name': 'Niterói', 'state_id': 2},
    {'id': 6, 'name': 'Belo Horizonte', 'state_id': 3},
    {'id': 7, 'name': 'Uberlândia', 'state_id': 3},
    {'id': 8, 'name': 'Curitiba', 'state_id': 4},
    {'id': 9, 'name': 'Londrina', 'state_id': 4},
    {'id': 10, 'name': 'Porto Alegre', 'state_id': 5},
    {'id': 11, 'name': 'Caxias do Sul', 'state_id': 5},
  ];
}
