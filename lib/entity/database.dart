import 'package:gerenciamento_de_estoque/entity/category.dart';
import 'package:gerenciamento_de_estoque/entity/product.dart';
import 'package:gerenciamento_de_estoque/entity/stock.dart';
import 'package:gerenciamento_de_estoque/entity/supplier.dart';

class Database {
  static List<Product> products = [];
  static List<Supplier> suppliers = [];
  static List<Category> categories = [];
  static Stock get stock => Stock(products: products);
}