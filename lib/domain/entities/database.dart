import 'package:gerenciamento_de_estoque/domain/entities/address.dart';
import 'package:gerenciamento_de_estoque/domain/entities/category.dart';
import 'package:gerenciamento_de_estoque/domain/entities/city.dart';
import 'package:gerenciamento_de_estoque/domain/entities/country.dart';
import 'package:gerenciamento_de_estoque/domain/entities/product.dart';
import 'package:gerenciamento_de_estoque/domain/entities/state.dart';
import 'package:gerenciamento_de_estoque/domain/entities/stock.dart';
import 'package:gerenciamento_de_estoque/domain/entities/supplier.dart';

class Database {
  static List<Product> products = [Product(name: "Banana", category: Category(name: "Comida", acronym: "CO", description: "Comida"), supplier: Supplier(name: "Luan", address: Address(addressLine2: "casa", city: City(name: "Porto Alegre", state: State(country: Country("Brasil"), acronym: "RS", name: "Rio Grande do Sul")), number: "1234", street: "Avenina Paraná"), email: "email@gmail", enterprise: "PHP", phoneNumber: "123"), buyPrice: 5.0, sellPrice: 7.5, amount: 2)];
  static List<Supplier> suppliers = [Supplier(name: "Gustavo", address: Address(addressLine2: "casa", city: City(name: "Alto Paraná", state: State(country: Country("Brasil"), acronym: "PR", name: "Paraná")), number: "1234", street: "Avenina Paraná"), email: "email@gmail", enterprise: "Java", phoneNumber: "123")];
  static List<Category> categories = [Category(name: "Eletrônico", acronym: "EL", description: "Eletrônico")];
  static Stock get stock => Stock(products: products);
}