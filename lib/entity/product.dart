import 'package:gerenciamento_de_estoque/entity/category.dart';
import 'package:gerenciamento_de_estoque/entity/supplier.dart';

class Product {
  String name;
  Category category;
  Supplier supplier;
  int amount;
  double sellPrice;
  double buyPrice;
  Product({required this.name, required this.category, required this.supplier, required this.buyPrice, required this.sellPrice, required this.amount});

}