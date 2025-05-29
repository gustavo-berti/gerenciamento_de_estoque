import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stock.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';

class Database {
  static List<Product> products = [Product(name: "Banana", category: Category(name: "Comida", acronym: "CO", description: "Comida"), supplier: Supplier(name: "Luan", address: "Paranavaí", email: "email@gmail", enterprise: "PHP", phoneNumber: "123"), buyPrice: 5.0, sellPrice: 7.5, amount: 2)];
  static List<Supplier> suppliers = [Supplier(name: "Gustavo", address: "Alto Paraná", email: "email@gmail", enterprise: "Java", phoneNumber: "123")];
  static List<Category> categories = [Category(name: "Eletrônico", acronym: "EL", description: "Eletrônico")];
  static Stock get stock => Stock(products: products);
}