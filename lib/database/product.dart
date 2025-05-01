import 'package:gerenciamento_de_estoque/database/category.dart';
import 'package:gerenciamento_de_estoque/database/supplier.dart';

class Product {
  String name;
  Category category;
  Supplier supplier;
  int amount = 0;
  Product({required this.name, required this.category, required this.supplier});


}