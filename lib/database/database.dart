import 'package:gerenciamento_de_estoque/database/category.dart';
import 'package:gerenciamento_de_estoque/database/product.dart';
import 'package:gerenciamento_de_estoque/database/stock_entry.dart';
import 'package:gerenciamento_de_estoque/database/stock_out.dart';
import 'package:gerenciamento_de_estoque/database/supplier.dart';

class Database {
  static List<Product> products = [];
  static List<Supplier> suppliers = [];
  static List<Category> categories = [];
  static List<StockEntry> entries = [];
  static List<StockOut> outies = [];
}