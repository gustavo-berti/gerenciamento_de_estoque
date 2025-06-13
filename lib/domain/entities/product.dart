import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product_supplier.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';

class Product {
  String name;
  Category category;
  Supplier supplier;
  int amount;
  final List<ProductSupplier> suppliers;
  Product({required this.name, required this.category, required this.supplier, required this.suppliers, required this.amount});

}